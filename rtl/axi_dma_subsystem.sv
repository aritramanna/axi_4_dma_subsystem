`timescale 1ns/1ps

////////////////////////////////////////////////////////////////////////////////
// Module Name: axi_dma_subsystem
// Description: Top-Level Wrapper for AXI4 DMA Subsystem
////////////////////////////////////////////////////////////////////////////////

module axi_dma_subsystem #(
    parameter AXI_ADDR_W = 32,
    parameter AXI_DATA_W = 128,
    parameter AXI_ID_W   = 4,
    // Core Parameters
    parameter FIFO_DEPTH = 256,
    parameter TIMEOUT_SRC_CYCLES = 100000,
    parameter TIMEOUT_DST_CYCLES = 100000
)(
    input  logic                    clk,
    input  logic                    rst_n,
    
    // AXI4-Lite Slave Interface (Control)
    input  logic [31:0]             cfg_s_axi_awaddr,
    input  logic                    cfg_s_axi_awvalid,
    output logic                    cfg_s_axi_awready,
    input  logic [31:0]             cfg_s_axi_wdata,
    input  logic [3:0]              cfg_s_axi_wstrb,
    input  logic                    cfg_s_axi_wvalid,
    output logic                    cfg_s_axi_wready,
    output logic [1:0]              cfg_s_axi_bresp,
    output logic                    cfg_s_axi_bvalid,
    input  logic                    cfg_s_axi_bready,
    input  logic [31:0]             cfg_s_axi_araddr,
    input  logic                    cfg_s_axi_arvalid,
    output logic                    cfg_s_axi_arready,
    output logic [31:0]             cfg_s_axi_rdata,
    output logic [1:0]              cfg_s_axi_rresp,
    output logic                    cfg_s_axi_rvalid,
    input  logic                    cfg_s_axi_rready,

    // AXI4 Master Interface (Data)
    output logic [AXI_ID_W-1:0]     m_axi_arid,
    output logic [AXI_ADDR_W-1:0]   m_axi_araddr,
    output logic [7:0]              m_axi_arlen,
    output logic [2:0]              m_axi_arsize,
    output logic [1:0]              m_axi_arburst,
    output logic                    m_axi_arvalid,
    input  logic                    m_axi_arready,
    input  logic [AXI_ID_W-1:0]     m_axi_rid,
    input  logic [AXI_DATA_W-1:0]   m_axi_rdata,
    input  logic [1:0]              m_axi_rresp,
    input  logic                    m_axi_rlast,
    input  logic                    m_axi_rvalid,
    output logic                    m_axi_rready,
    output logic [AXI_ID_W-1:0]     m_axi_awid,
    output logic [AXI_ADDR_W-1:0]   m_axi_awaddr,
    output logic [7:0]              m_axi_awlen,
    output logic [2:0]              m_axi_awsize,
    output logic [1:0]              m_axi_awburst,
    output logic                    m_axi_awvalid,
    input  logic                    m_axi_awready,
    output logic [AXI_DATA_W-1:0]   m_axi_wdata,
    output logic [AXI_DATA_W/8-1:0] m_axi_wstrb,
    output logic                    m_axi_wlast,
    output logic                    m_axi_wvalid,
    input  logic                    m_axi_wready,
    input  logic [AXI_ID_W-1:0]     m_axi_bid,
    input  logic [1:0]              m_axi_bresp,
    input  logic                    m_axi_bvalid,
    output logic                    m_axi_bready,

    // Interrupt Output (Pending Status)
    output logic                    intr_pend
);

    // internal signals and control logic 

    // instantiate dma_reg_block

    // instantiate axi_dma_master 

endmodule
