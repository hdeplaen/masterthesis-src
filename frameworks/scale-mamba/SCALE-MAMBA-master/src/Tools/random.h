/*
Copyright (c) 2017, The University of Bristol, Senate House, Tyndall Avenue, Bristol, BS8 1TH, United Kingdom.
Copyright (c) 2018, COSIC-KU Leuven, Kasteelpark Arenberg 10, bus 2452, B-3001 Leuven-Heverlee, Belgium.

All rights reserved
*/
#ifndef _random
#define _random

#include "aes.h"
#include "int.h"

#define PIPELINES 8
#define SEED_SIZE AES_BLK_SIZE
#define RAND_SIZE (PIPELINES * AES_BLK_SIZE)

/* This basically defines a randomness expander, if using
 * as a real PRG on an input stream you should first collapse
 * the input stream down to a SEED, say via CBC-MAC (under 0 key)
 * or via a hash
 */

// __attribute__ is needed to get the sse instructions to avoid
//  seg faulting.

class PRNG
{
  uint8_t seed[SEED_SIZE];
  uint8_t state[RAND_SIZE] __attribute__((aligned(16)));
  uint8_t random[RAND_SIZE] __attribute__((aligned(16)));

  bool useC;

  // Two types of key schedule for the different implementations
  // of AES
  uint KeyScheduleC[44];
  uint8_t KeySchedule[176] __attribute__((aligned(16)));

  int cnt; // How many bytes of the current random value have been used

  void hash(); // Hashes state to random and sets cnt=0
  void next();

public:
  PRNG();

  // For debugging
  void print_state() const;

  // Set seed from dev/random and Init the generator
  //   - Takes the thread number to ensure divergence
  //     in different threads. Recommended by Tancrede
  //     Lepoint
  void ReSeed(int thread);

  // Set seed from array of size SEED_SIZE
  void SetSeed(unsigned char *);

  // Get a seed out of G
  void SetSeed(PRNG &G);

  // Take seed and initialize the PRNG
  void InitSeed();

  double get_double();
  unsigned char get_uchar();
  unsigned int get_uint();
  word get_word()
  {
    word a= get_uint();
    a<<= 32;
    a+= get_uint();
    return a;
  }

  const uint8_t *get_seed() const
  {
    return seed;
  }

  /* Returns len random bytes */
  void get_random_bytes(uint8_t *v, int len);
};

#endif
