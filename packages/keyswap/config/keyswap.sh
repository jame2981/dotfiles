#!/bin/bash
# Swap Right Option (0x7000000e6) and Right Command (0x7000000e7)
hidutil property --set '{"UserKeyMapping":
  [{"HIDKeyboardModifierMappingSrc":0x7000000e6,
    "HIDKeyboardModifierMappingDst":0x7000000e7},
   {"HIDKeyboardModifierMappingSrc":0x7000000e7,
    "HIDKeyboardModifierMappingDst":0x7000000e6}]
}'
