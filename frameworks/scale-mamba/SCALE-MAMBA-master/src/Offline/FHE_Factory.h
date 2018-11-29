/*
Copyright (c) 2017, The University of Bristol, Senate House, Tyndall Avenue, Bristol, BS8 1TH, United Kingdom.
Copyright (c) 2018, COSIC-KU Leuven, Kasteelpark Arenberg 10, bus 2452, B-3001 Leuven-Heverlee, Belgium.

All rights reserved
*/
#ifndef _FHE_Factory
#define _FHE_Factory

/* This class allow the control of the FHE Factories
 * which produce "valid" ciphertexts via the ZKPoK
 * machinary.
 *
 * A set of Factories is called an Industry :-)
 *
 */

#include "FHE/ZKPoK.h"
#include "System/Player.h"
#include "offline_data.h"
#include <mutex>
using namespace std;

class FHE_Industry
{

  vector<list<ZKPoK>> Factory;
  mutex *Factory_List_Lock;
  mutex *Current_Factory_Lock;
  vector<int> batch_number;
  vector<ZKPoK> Current_Factory;
  // Counter for printing for debugging purposes
  vector<unsigned int> zkc;

  // The encryptions of the macs
  vector<Ciphertext> ctx_macs;

  // Assume Current_Factory_Lock[num] is locked!!!
  //   Returns -1 if we should exit, else 0
  //   Checks whether we should close all the factories
  int Update_If_Empty(unsigned int num, unsigned int num_online,
                      offline_control_data &OCD);

public:
  FHE_Industry(unsigned int maxnumber);
  ~FHE_Industry();

  const Ciphertext &ct_mac(unsigned int i) const
  {
    return ctx_macs[i];
  }

  /* If one party says every thread is finished then signal we should finish */
  bool is_finished(unsigned int num, Player &P, const offline_control_data &OCD);

  /* Returns the number within the factory used for checking purposes
   *   -1 if should exit
   */
  int Next_Off_Production_Line(Plaintext &mess, Ciphertext &ctx,
                               const Player &P, unsigned int num_online,
                               offline_control_data &OCD);

  void increment_zkc(unsigned int num)
  {
    zkc[num]++;
  }
  unsigned int get_zkc(unsigned int num)
  {
    return zkc[num];
  }

  /* Runs the factory in FHE_Factory thread mynumber 
   * Returns when the factory closes down
   */
  void FHE_Factory(Player &P, const offline_control_data &OCD, const FHE_PK &pk,
                   const FFT_Data &PTD, unsigned int mynumber, int verbose);
};

#endif
