# AXI4 DMA Subsystem - Verilog RTL Design Task

## Submission Summary

**Submitted by**: Aritra Manna  
**Submission Date**: December 15, 2024  
**Contact**: sonya@phinity.ai  
**Repository**: https://github.com/aritramanna/axi_4_dma_subsystem  
**Evaluation Link**: https://hud.ai/jobs/02baab4f-a987-4bf9-972d-53666b832b4b

---

## Evaluation Results

### Evolution of Difficulty & Pass Rate

We conducted two major evaluation runs to tune the problem difficulty. The key finding is that **Prompt Engineering works comprehensively**: a single specific constraint added to the prompt moved the pass rate from 3% to 83%.

#### Run 1: The "Implicit Spec" Failure (3% Pass)

- **Job Link**: [View Results](https://www.hud.ai/jobs/a2b89059-db86-439f-b98a-3fdd8b34a75c)
- **Pass Rate**: 3% (1/30 agents)
- **Cause**: The prompt broadly requested an "AXI4 DMA" without explicitly mentioning latency constraints. Most agents followed standard FPGA design practices and **registered their output signals** for better timing closure.
- **Result**: This broke the "Zero-Latency" requirement of the testbench, causing massive throughput failures (latency bubbles) even though the logic was functionally correct.

#### Run 2: The "Explicit Constraint" Success (83% Pass)

- **Job Link**: [View Results](https://www.hud.ai/jobs/b3a72fb6-d0d8-4acc-8d23-cc4a93126cf4)
- **Pass Rate**: 83% (25/30 agents)
- **Difference**: We updated `prompt.txt` to explicitly state:
  > _"To satisfy the 100% throughput performance test, the AXI Master interface signals ... MUST be driven combinationally ... Do NOT add output registers"_
- **Result**: Agents successfully adhered to this constraint. The pass rate skyrocketed, proving the agents were capable of complex logic (FWFT FIFO, Skid Buffer, AXI FSM) as long as critical performance constraints were explicit.

### Difficulty Assessment: Missed Target

**Target Difficulty**: 10-40% Pass Rate (Hard)
**Actual Difficulty**: 83% (Too Easy given the new prompt)

We acknowledge that we **failed to meet the 10-40% difficulty goal** with the final configuration. The problem is inherently complex (requiring 400+ lines of RTL, FSMs, and custom FIFOs), but the final prompt provided such clear architectural guidance ("The Golden Hint") that it trivialized the specific challenge that made the task "Hard".

**Conclusion**: To return this to a "Hard" problem, we would need to remove the explicit implementation hint about combinational usage and rely on the agent strictly deriving "100% throughput" requirements from the Specification document alone.

---

## Repository Structure

```
axi4_dma_sub_system/
├── README.md                          # This submission document
├── docs/
│   └── Specification.md               # Complete design specification (detailed requirements)
├── prompt.txt                         # Agent task prompt (174 lines)
├── pyproject.toml                     # Python dependencies (cocotb, pytest)
│
├── harness/                           # Original test harness (for reference)
│   ├── patch/
│   │   └── rtl/                       # Golden solution files (original location)
│   │       ├── axi_4_dma.sv
│   │       ├── axi_dma_subsystem.sv
│   │       ├── dma_reg_block.sv
│   │       └── fifo.sv
│   └── test/
│       └── test_axi_dma_hidden.py     # Original test file (without pytest wrapper)
│
├── rtl/                               # Original baseline directory
│   └── axi_dma_subsystem.sv           # Empty skeleton (original location)
│
├── sources/                           # HUD-format RTL directory (used by framework)
│   ├── axi_dma_subsystem.sv           # Top-level wrapper
│   ├── axi_4_dma.sv                   # DMA protocol engine
│   ├── dma_reg_block.sv               # Register interface
│   └── fifo.sv                        # FWFT FIFO with skid buffer
│
└── tests/                             # HUD-format test directory (used by framework)
    └── test_axi_dma_hidden.py         # 16 cocotb tests + pytest wrapper

Git Branches:
- main: Complete repository with all directories
- axi4_dma_baseline: Empty implementation (sources/axi_dma_subsystem.sv only), NO tests/
- axi4_dma_test: Baseline + tests/ directory (for grading)
- axi4_dma_golden: Complete solution in sources/, NO tests/
```

**Note**: The `harness/` and `rtl/` directories contain the original problem structure. The HUD framework uses `sources/` and `tests/` directories as specified in the branch structure above.

---

## Task Overview

This task requires implementing a complete AXI4 DMA (Direct Memory Access) subsystem in SystemVerilog, including a store-and-forward DMA engine with FWFT (First-Word Fall-Through) FIFO, AXI4-Lite control interface, and comprehensive error handling.

---

## Why This Task Was Chosen

### Technical Complexity

The AXI4 DMA subsystem represents a **real-world, production-grade hardware design challenge** that tests multiple critical skills:

1. **Protocol Implementation**: Requires deep understanding of AMBA AXI4 and AXI4-Lite protocols
2. **State Machine Design**: Complex FSM with multiple states for read/write phases, error handling, and timeout management
3. **FIFO Architecture**: Implementation of FWFT FIFO with skid buffer to avoid timing violations
4. **Error Detection**: Comprehensive validation including alignment checks, boundary protection, and protocol error handling
5. **Multi-Module Integration**: Coordination between 4 separate modules with well-defined interfaces

---

## Industry Relevance

### Real-World Applications

**1. System-on-Chip (SoC) Design**

- DMA engines are fundamental components in modern SoCs
- Used in processors from ARM, RISC-V, and x86 architectures
- Critical for high-performance data movement in embedded systems

**2. Data Center & Cloud Infrastructure**

- Network interface cards (NICs) use DMA for packet processing
- Storage controllers rely on DMA for high-throughput I/O
- GPU-CPU communication in AI/ML accelerators

**3. Automotive & IoT**

- ADAS (Advanced Driver Assistance Systems) sensor data processing
- Real-time video streaming in automotive cameras
- Industrial automation and robotics control systems

**4. Consumer Electronics**

- Mobile SoC designs (Qualcomm, MediaTek, Apple Silicon)
- Smart TVs and set-top boxes for video processing
- Gaming consoles for memory-intensive operations

### Industry Standards Compliance

This task enforces adherence to:

- **AMBA AXI4 Specification** (ARM IHI 0022E)
- **Industry best practices** for timing closure (skid buffer requirement)
- **Production-quality error handling** (alignment, boundary checks, timeouts)

## Problem Context & Codebase Description

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   AXI4 DMA Subsystem                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐      ┌─────────────────┐                  │
│  │              │      │                 │                  │
│  │ dma_reg_block│◄────►│  axi_dma_master │                  │
│  │  (AXI4-Lite) │      │   (DMA Engine)  │                  │
│  │              │      │                 │                  │
│  └──────────────┘      └────────┬────────┘                  │
│         │                       │                           │
│         │                       ▼                           │
│         │              ┌─────────────────┐                  │
│         │              │  fifo_bram_fwft │                  │
│         │              │  (Skid Buffer)  │                  │
│         │              └─────────────────┘                  │
│         │                                                   │
│         ▼                       ▼                           │
│   Control/Status          AXI4 Master                       │
│   (Registers)            (Memory Access)                    │
└─────────────────────────────────────────────────────────────┘
```

### Module Breakdown

**1. `axi_dma_subsystem.sv` (Top-Level Wrapper)**

- Instantiates and connects all sub-modules
- Exposes AXI4-Lite slave and AXI4 master interfaces
- Manages interrupt output

**2. `dma_reg_block.sv` (Register Interface)**

- Implements 5 memory-mapped registers (CTRL, STATUS, SRC, DST, LEN)
- Handles AXI4-Lite protocol with full backpressure support
- Provides W1C (Write-1-to-Clear) semantics for status bits
- Generates interrupt signals based on IntEn configuration

**3. `axi_4_dma.sv` (DMA Protocol Engine)**

- **Store-and-Forward Architecture**: Reads entire burst into FIFO before writing
- **Parameter Validation**: Checks alignment (16-byte), length (≤4096), 4KB boundaries
- **Watchdog Timers**: Detects stuck transactions on source/destination
- **Error Handling**: Maps AXI BRESP/RRESP errors to status codes
- **State Machine**: IDLE → VALIDATE → READ → WRITE → DONE/ERROR

**4. `fifo.sv` (FWFT FIFO with Skid Buffer)**

- **Critical Constraint**: Must NOT use combinational BRAM-to-output path
- **Skid Buffer**: Output pipeline register for timing closure
- **FWFT Behavior**: Data available on `dout` when `empty=0` (0-cycle latency)
- **Depth**: 256 entries × 128-bit data width

### Key Design Challenges

**1. Timing Closure**
The specification explicitly prohibits direct combinational paths from BRAM to output, forcing implementation of a skid buffer. This is a real-world constraint faced in ASIC/FPGA designs.

**2. Protocol Compliance**

- AXI4-Lite: Must handle backpressure on all 5 channels (AW, W, B, AR, R)
- AXI4: Must maintain VALID/READY handshake rules and signal stability
- ID matching: Read/write transaction IDs must be managed correctly

**3. Edge Case Handling**

- Overlapping memory regions (src/dst overlap)
- 4KB boundary crossing detection
- Concurrent interrupt pending and new start command
- Mid-flight reset recovery

### Test Coverage (18 Comprehensive Tests)

1. **Basic Functionality**: Standard 64-byte transfer
2. **Control Logic**: Block start if interrupt pending
3. **Interrupt Handling**: W1C persistence and masking
4. **Register Validation**: Invalid address SLVERR responses
5. **Length Boundaries**: Zero, max (4096), oversize detection
6. **Alignment**: 16-byte alignment enforcement
7. **4KB Boundary**: Source and destination crossing detection
8. **Data Integrity**: Back-to-back transfers
9. **Stress Testing**: Random AXI delays and backpressure
10. **Overlap Handling**: Forward and reverse overlapping regions
11. **Reset Recovery**: Mid-flight asynchronous reset
12. **AXI Errors**: SLVERR/DECERR response handling
13. **Interrupt Masking**: IntEn=0 behavior
14. **Watchdog Timers**: Source/destination timeout detection
15. **Throughput**: 1 cycle/beat performance validation
16. **Protocol Invariants**: AXI signal stability and WLAST consistency
17. **FIFO Reset (Source)**: Verify FIFO soft reset prevents stale data corruption after source timeout
18. **FIFO Reset (Destination)**: Verify FIFO soft reset prevents stale data corruption after destination timeout

## Technical Specifications

**Design Constraints**:

- Language: SystemVerilog
- Clock Domain: Single (synchronous design)
- Reset: Asynchronous active-low (`rst_n`)
- Data Width: 128-bit AXI4 master
- Address Width: 32-bit
- Max Transfer: 4096 bytes
- FIFO Depth: 256 entries

**Interface Summary**:

- 1× AXI4-Lite Slave (32-bit, control registers)
- 1× AXI4 Master (128-bit, data transfers)
- 1× Interrupt output (`intr_pend`)

**Performance Requirements**:

- Throughput: 1 cycle per beat during bursts
- Latency: Store-and-forward (read complete before write)
- Timeout: Configurable watchdog (default 100k cycles)

---

## Why This Task is Valuable for RL Training

1. **Multi-Step Reasoning**: Requires planning across 4 modules with dependencies
2. **Specification Adherence**: Must extract requirements from 174-line prompt + detailed spec
3. **Debugging Skills**: Failed tests provide rich feedback for learning
4. **Real-World Constraints**: Timing, protocol compliance, edge cases mirror industry challenges
5. **Scalable Difficulty**: Can be made harder by adding features (scatter-gather, linked lists, etc.)

---

## License & Usage

This task is submitted for inclusion in the Phinity AI HUD training dataset for reinforcement learning research and development.
