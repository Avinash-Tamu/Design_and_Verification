#include "assert.H"
#include "exceptions.H"
#include "console.H"
#include "paging_low.H"
#include "page_table.H"

PageTable * PageTable::current_page_table = nullptr;
unsigned int PageTable::paging_enabled = 0;
ContFramePool * PageTable::kernel_mem_pool = nullptr;
ContFramePool * PageTable::process_mem_pool = nullptr;
unsigned long PageTable::shared_size = 0;



void PageTable::init_paging(ContFramePool * _kernel_mem_pool,
                            ContFramePool * _process_mem_pool,
                            const unsigned long _shared_size)
{
   PageTable::kernel_mem_pool = _kernel_mem_pool;
   PageTable::process_mem_pool = _process_mem_pool;
   PageTable::shared_size = _shared_size;
   
   Console::puts("Initialized Paging System\n");
}


PageTable::PageTable()
{   
   unsigned int index = 0;
   unsigned long address = 0;
   
   // Paging is disabled at first
   paging_enabled = 0;
   
   // Calculate number of frames shared - 4 MB / 4 KB = 1024
   unsigned long num_shared_frames = ( PageTable::shared_size / PAGE_SIZE );
   
   // Initialize page directory
   page_directory = (unsigned long *)( kernel_mem_pool->get_frames(1) * PAGE_SIZE );
   
   // Initialize page table
   unsigned long * page_table = (unsigned long *)( kernel_mem_pool->get_frames(1) * PAGE_SIZE );
   
   // Initializing page directory entries (PDEs) - Mark 1st PDE as valid
   page_directory[0] = ( (unsigned long)page_table | 0b11 );			
   
   // Remaining PDEs are marked invalid
   for( index = 1; index < num_shared_frames; index++ )
   {
	   page_directory[index] = ( page_directory[index] | 0b10 );		
   }
   
   // Mapping first 4 MB of memory for page table - All pages marked as valid
   for( index = 0; index < num_shared_frames; index++ )
   {
	   page_table[index] = (address | 0b11);							   
	   address = address + PAGE_SIZE;
   }
   
   Console::puts("Constructed Page Table object\n");
}


void PageTable::load()
{
   current_page_table = this;
   
   // Write page directory address into CR3 register
   write_cr3((unsigned long)(current_page_table->page_directory));
   
   Console::puts("Loaded page table\n");
}


void PageTable::enable_paging()
{
   write_cr0( read_cr0() | 0x80000000 );	// Set paging bit - 32nd bit
   paging_enabled = 1;						// Set paging_enabled variable
   
   Console::puts("Enabled paging\n");
}


void PageTable::handle_fault(REGS * _r)
{
	unsigned int index = 0;
	
	unsigned long error_code = _r->err_code;

	// Get the page fault address from CR2 register
	unsigned long fault_address = read_cr2();

	// Get the page directory address from CR3 register
	unsigned long * page_dir = (unsigned long *)read_cr3();

	// Extract page directory index - first 10 bits
	unsigned long page_dir_index = (fault_address >> 22);

	// Extract page table index using mask - next 10 bits
	unsigned long page_table_index = ( (fault_address >> 12) & 0x3FF );		

	unsigned long * new_page_table = nullptr;

	// If page not present fault occurs
	if ((error_code & 1) == 0 )
	{
		// Check where page fault occured
		if ((page_dir[page_dir_index] & 1 ) == 0)
		{
			page_dir[page_dir_index] = (unsigned long)(kernel_mem_pool->get_frames(1)*PAGE_SIZE | 0b11);		
			new_page_table = (unsigned long *)(page_dir[page_dir_index] & 0xFFFFF000);
			for(index=0; index < 1024; index++)
			{
				new_page_table[index] = 0b100;
			}
		}

		else
		{
			new_page_table = (unsigned long *)(page_dir[page_dir_index] & 0xFFFFF000);
			new_page_table[page_table_index] =  PageTable::process_mem_pool->get_frames(1)*PAGE_SIZE | 0b11;	
		}
	}

	Console::puts("handled page fault\n");
}

