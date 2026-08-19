# Verification Plan

## Synchronous Memory IP 16 x 32

## 1. Introduction

This document defines the verification plan for the MEM_16x32 synchronous memory. It captures the design intent, verification methodology, exit criteria, test items, coverage goals, and the traceability between requirements and tests. The goal is to ensure that the memory IP operates correctly across reset, write, read, address boundary, and all-address functional scenarios.

## 2. Design Overview

MEM_16x32 is a single-port synchronous memory with:

- 16 memory locations
- 32-bit data width per location
- 4-bit address bus
- synchronous write/read behavior controlled by the Enable signal
- asynchronous active-low reset
- one-cycle registered valid/data behavior on read

### 2.1 Interface Signals

| Signal | Direction | Width | Description |
| -------- | ----------- | ------- | ------------- |
| CLK | Input | 1 bit | System clock, positive-edge triggered |
| Reset | Input | 1 bit | Asynchronous, active-low reset |
| Enable | Input | 1 bit | 1 = write cycle, 0 = read cycle |
| Address | Input | 4 bits | Memory location selection |
| Data_in | Input | 32 bits | Write data |
| Data_out | Output | 32 bits | Read data |
| Valid | Output | 1 bit | Indicates a valid read data cycle |

### 2.2 Functional Behavior

- On every clock cycle, the memory operates as either a write or a read depending on the Enable signal.
- When Reset is asserted, the output values are forced to zero and the valid flag is deasserted.
- For a read cycle, the data returned from the addressed location is captured with one-cycle latency.
- The Valid signal is expected to reflect the read-data validity timing with a one-cycle delayed relationship to the enable state.

## 3. Verification Strategy

The verification approach combines:

- directed tests for reset, boundary conditions, and functional timing checks
- constrained-random regression for write/read scenarios and wide data/address variation
- a self-checking scoreboard/reference model to compare expected versus actual memory behavior

The reference model tracks the internal memory array and predicts the correct Data_out and Valid behavior with the proper one-cycle latency.

## 4. Test Cases

| TC_ID | Description | Expected Result | Stimulus | Priority |
| ------- | ------------- | ----------------- | ---------- | ---------- |
| TC_01 | Reset the system | Data_out = 0, Valid = 0 | Reset asserted (Rst_n = 0) | High |
| TC_02 | Write operation | Memory location is updated with Data_in at the selected address | Enable = 1, random address, random Data_in | High |
| TC_03 | Read operation | Data_out matches the stored value at the selected address; Valid = 1 after one cycle | Enable = 0, random address | High |
| TC_04 | Valid_out timing | valid_out = ~enable delayed by one clock cycle | Enable toggled 0 → 1 → 0 → 1 | High |
| TC_05 | Address boundaries | Correct write/read at addresses 0x0 and 0xF | Write/read at address 0x0 and then 0xF | Medium |
| TC_06 | All-address sweep | All 16 memory locations are correctly written and then read back | Write 16 unique values across all addresses, then read them back | Medium |

## 5. Traceability Matrix

| TC_ID | Enable | Reset | Valid |
| ------- | -------- | ------- | ------- |
| TC_01 | - | Yes | Yes |
| TC_02 | Yes | - | - |
| TC_03 | Yes | - | Yes |
| TC_04 | Yes | - | Yes |
| TC_05 | Yes | - | Yes |
| TC_06 | Yes | - | Yes |

## 6. Coverage and Exit Criteria

### 6.1 Functional Coverage Goals

- All input ports exercised across valid and invalid conditions
- Reset behavior covered for both asserted and deasserted states
- Write and read transactions covered across random addresses and data values
- Boundary addresses 0x0 and 0xF covered
- Valid timing checked for all relevant transitions

### 6.2 Exit Criteria

The verification is considered complete when all of the following are true:

- All planned test cases have been executed and passed in QuestaSim
- 100% code coverage is achieved on the simulator
- Functional coverage is achieved for all ports and relevant internal signals
- No linting issues remain

## 7. Coverage Results

To be completed after simulation and regression execution.
