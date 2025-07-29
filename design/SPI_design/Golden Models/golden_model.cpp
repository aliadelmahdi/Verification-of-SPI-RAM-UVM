#include <cstdint>

extern "C" {

#define MEM_DEPTH 256
static uint8_t mem[MEM_DEPTH] = {0};

// Write to memory
void dpi_spi_mem_write(uint8_t addr, uint8_t data) {
    mem[addr] = data;
}

// Read from memory
uint8_t dpi_spi_mem_read(uint8_t addr) {
    return mem[addr];
}

}