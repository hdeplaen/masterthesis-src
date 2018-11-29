/*
Copyright (c) 2017, The University of Bristol, Senate House, Tyndall Avenue, Bristol, BS8 1TH, United Kingdom.
Copyright (c) 2018, COSIC-KU Leuven, Kasteelpark Arenberg 10, bus 2452, B-3001 Leuven-Heverlee, Belgium.

All rights reserved
*/
#ifndef _Offline_FHE
#define _Offline_FHE

/* The offline phases which rely on FHE */

#include <list>
using namespace std;

#include "FHE_Factory.h"
#include "LSSS/Open_Protocol.h"
#include "LSSS/PRSS.h"
#include "Offline/offline_data.h"

void offline_FHE_triples(Player &P, list<Share> &a, list<Share> &b,
                         list<Share> &c, const FHE_PK &pk, const FHE_SK &sk,
                         const FFT_Data &PTD,
                         int num_online, offline_control_data &OCD,
                         FHE_Industry &industry);

void offline_FHE_squares(Player &P, list<Share> &a, list<Share> &b,
                         const FHE_PK &pk, const FHE_SK &sk,
                         const FFT_Data &PTD,
                         int num_online, offline_control_data &OCD,
                         FHE_Industry &industry);

void offline_FHE_bits(Player &P, list<Share> &a, const FHE_PK &pk,
                      const FHE_SK &sk, const FFT_Data &PTD,
                      int num_online, offline_control_data &OCD,
                      FHE_Industry &industry);

void offline_FHE_IO(Player &P, unsigned int player_num, list<Share> &a,
                    list<gfp> &opened, const FHE_PK &pk, const FHE_SK &sk,
                    const FFT_Data &PTD, Open_Protocol &OP,
                    int num_online, offline_control_data &OCD,
                    FHE_Industry &industry);

#endif
