/*
 File: ContFramePool.C
 
 Author: Avinash Singh
 Date  : 02-08-2026
 
 */

/*--------------------------------------------------------------------------*/
/* 
 POSSIBLE IMPLEMENTATION
 -----------------------

 The class SimpleFramePool in file "simple_frame_pool.H/C" describes an
 incomplete vanilla implementation of a frame pool that allocates 
 *single* frames at a time. Because it does allocate one frame at a time, 
 it does not guarantee that a sequence of frames is allocated contiguously.
 This can cause problems.
 
 The class ContFramePool has the ability to allocate either single frames,
 or sequences of contiguous frames. This affects how we manage the
 free frames. In SimpleFramePool it is sufficient to maintain the free 
 frames.
 In ContFramePool we need to maintain free *sequences* of frames.
 
 This can be done in many ways, ranging from extensions to bitmaps to 
 free-lists of frames etc.
 
 IMPLEMENTATION:
 
 One simple way to manage sequences of free frames is to add a minor
 extension to the bitmap idea of SimpleFramePool: Instead of maintaining
 whether a frame is FREE or ALLOCATED, which requires one bit per frame, 
 we maintain whether the frame is FREE, or ALLOCATED, or HEAD-OF-SEQUENCE.
 The meaning of FREE is the same as in SimpleFramePool. 
 If a frame is marked as HEAD-OF-SEQUENCE, this means that it is allocated
 and that it is the first such frame in a sequence of frames. Allocated
 frames that are not first in a sequence are marked as ALLOCATED.
 
 NOTE: If we use this scheme to allocate only single frames, then all 
 frames are marked as either FREE or HEAD-OF-SEQUENCE.
 
 NOTE: In SimpleFramePool we needed only one bit to store the state of 
 each frame. Now we need two bits. In a first implementation you can choose
 to use one char per frame. This will allow you to check for a given status
 without having to do bit manipulations. Once you get this to work, 
 revisit the implementation and change it to using two bits. You will get 
 an efficiency penalty if you use one char (i.e., 8 bits) per frame when
 two bits do the trick.
 
 DETAILED IMPLEMENTATION:
 
 How can we use the HEAD-OF-SEQUENCE state to implement a contiguous
 allocator? Let's look a the individual functions:
 
 Constructor: Initialize all frames to FREE, except for any frames that you 
 need for the management of the frame pool, if any.
 
 get_frames(_n_frames): Traverse the "bitmap" of states and look for a 
 sequence of at least _n_frames entries that are FREE. If you find one, 
 mark the first one as HEAD-OF-SEQUENCE and the remaining _n_frames-1 as
 ALLOCATED.

 release_frames(_first_frame_no): Check whether the first frame is marked as
 HEAD-OF-SEQUENCE. If not, something went wrong. If it is, mark it as FREE.
 Traverse the subsequent frames until you reach one that is FREE or 
 HEAD-OF-SEQUENCE. Until then, mark the frames that you traverse as FREE.
 
 mark_inaccessible(_base_frame_no, _n_frames): This is no different than
 get_frames, without having to search for the free sequence. You tell the
 allocator exactly which frame to mark as HEAD-OF-SEQUENCE and how many
 frames after that to mark as ALLOCATED.
 
 needed_info_frames(_n_frames): This depends on how many bits you need 
 to store the state of each frame. If you use a char to represent the state
 of a frame, then you need one info frame for each FRAME_SIZE frames.
 
 A WORD ABOUT RELEASE_FRAMES():
 
 When we releae a frame, we only know its frame number. At the time
 of a frame's release, we don't know necessarily which pool it came
 from. Therefore, the function "release_frame" is static, i.e., 
 not associated with a particular frame pool.
 
 This problem is related to the lack of a so-called "placement delete" in
 C++. For a discussion of this see Stroustrup's FAQ:
 http://www.stroustrup.com/bs_faq2.html#placement-delete
 
 */
/*--------------------------------------------------------------------------*/


/*--------------------------------------------------------------------------*/
/* DEFINES */
/*--------------------------------------------------------------------------*/

/* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* INCLUDES */
/*--------------------------------------------------------------------------*/

#include "cont_frame_pool.H"
#include "console.H"
#include "utils.H"
#include "assert.H"
#include <stddef.h>

/*--------------------------------------------------------------------------*/
/* DATA STRUCTURES */
/*--------------------------------------------------------------------------*/

/* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* CONSTANTS */
/*--------------------------------------------------------------------------*/

/* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* FORWARDS */
/*--------------------------------------------------------------------------*/

ContFramePool * ContFramePool::head = nullptr;

/*--------------------------------------------------------------------------*/
/* METHODS FOR CLASS   C o n t F r a m e P o o l */
/*--------------------------------------------------------------------------*/

ContFramePool::ContFramePool(unsigned long _base_frame_no,
                             unsigned long _n_frames,
                             unsigned long _info_frame_no)
{
    assert(_n_frames > 0);

    base_frame_no = _base_frame_no;
    nframes = _n_frames;
    info_frame_no = _info_frame_no;
    nFreeFrames = _n_frames;

    // if _info_frame_no is 0 then keep management frame info in first frame 
    if (info_frame_no == 0){
        bitmap = (unsigned char*) (base_frame_no * FRAME_SIZE);
    } else {
        bitmap = (unsigned char*) (info_frame_no * FRAME_SIZE);
    }

    // Initialize bitmap to Free
    for(unsigned long fno = 0; fno < nframes; fno++){
        set_state(fno, FrameState::Free);
    }

    //mark first frame as used because frame is allocated for management info
    if (_info_frame_no == 0){
        set_state(0, FrameState::Used);
        nFreeFrames--;
    }

    //creating a linkedlist and adding new frame
    next = nullptr;
    if ( head == nullptr){
        head = this;
    } else {
        ContFramePool *temp = head;
        while(temp->next != nullptr)
            temp = temp->next;
        temp->next = this;
    }

    Console::puts("Frame pool initialized\n");
}

ContFramePool::FrameState 
ContFramePool::get_state(unsigned long _frame_no)
{
    unsigned int bitmap_row_idx = (_frame_no / 4);
    unsigned int bitmap_col_idx = ((_frame_no % 4) * 2);

    unsigned char mask = (bitmap[bitmap_row_idx] >> bitmap_col_idx) & 0b11;

    if(mask == 0b00)
        return FrameState::Free;

    if(mask == 0b01)
        return FrameState::Used;

    if(mask == 0b11)
        return FrameState::HoS;

    return FrameState::Free;
}

void ContFramePool::set_state(unsigned long _frame_no, FrameState _state) 
{
    unsigned int bitmap_row_idx = (_frame_no / 4);
    unsigned int bitmap_col_idx = ((_frame_no % 4) * 2);

    // Clear the 2 bits
    bitmap[bitmap_row_idx] &= ~(3 << bitmap_col_idx);

    switch(_state){
        case FrameState::Free:
            break;

        case FrameState::Used:
            bitmap[bitmap_row_idx] |= (1 << bitmap_col_idx);
            break;

        case FrameState::HoS:
            bitmap[bitmap_row_idx] |= (3 << bitmap_col_idx);
            break;
    }
}

unsigned long ContFramePool::get_frames(unsigned int _n_frames)
{
    if(_n_frames == 0 || _n_frames > nFreeFrames){
        Console::puts("ContframePool::get_frames invalid request!\n");
        return 0;
    }

    unsigned int free_frames_start = 0;
    unsigned int free_frames_count = 0;

    for (unsigned int i = 0; i < nframes; i++){
        if (get_state(i) == FrameState::Free){
            if(free_frames_count == 0){
                free_frames_start = i;
            }
            free_frames_count++;

            if(free_frames_count == _n_frames)
                break;
        }
        else{
            free_frames_count = 0;
        }
    }

    if (free_frames_count != _n_frames){
        Console::puts("ContframePool::get_frames - Continuous free frames not available\n");
        return 0;
    }

    // Mark allocated sequence
    set_state(free_frames_start, FrameState::HoS);

    for(unsigned int i = 1; i < _n_frames; i++){
        set_state(free_frames_start + i, FrameState::Used);
    }

    nFreeFrames -= _n_frames;

    unsigned long first_frame = free_frames_start + base_frame_no;
    unsigned long last_frame  = first_frame + _n_frames - 1;

    Console::puts("ContFramePool::Allocated frames ");
    Console::puti(first_frame);
    Console::puts(" to ");
    Console::puti(last_frame);
    Console::puts("\n");

    return first_frame;
}

void ContFramePool::mark_inaccessible(unsigned long _base_frame_no,
                                      unsigned long _n_frames)
{	
	if(	(_base_frame_no + _n_frames ) > (base_frame_no + nframes) || (_base_frame_no < base_frame_no) )
	{
		Console::puts("ContframePool::mark_inaccessible - Range out of bounds. Cannot mark inacessible.\n");
		assert(false);
		return;
	}
	Console::puts("Mark Inaccessible: _base_frame_no = "); Console::puti(_base_frame_no);
	Console::puts(" _n_frames ="); Console::puti(_n_frames);Console::puts("\n");


	unsigned int idx = 0;
	for( idx = _base_frame_no; idx < (_base_frame_no + _n_frames); idx++ )
	{
		if( get_state(idx - base_frame_no) == FrameState::Free )
		{
			if( idx == _base_frame_no )
			{
				set_state( (idx - base_frame_no), FrameState::HoS);
			}
			else
			{
				set_state( (idx - base_frame_no), FrameState::Used );
			}
			
			nFreeFrames = nFreeFrames - 1;
		}
	}
	
	return;
}

void ContFramePool::release_frames(unsigned long _first_frame_no)
{
    ContFramePool *temp = head;

    while(temp != nullptr){
        if ((_first_frame_no >= temp->base_frame_no) &&
            (_first_frame_no < (temp->base_frame_no + temp->nframes)) ) {
            temp->release_frames_in_pool(_first_frame_no);
            Console::puts("ContFramePool::Frame ");
            Console::puti(_first_frame_no);
            Console::puts(" released successfully\n");
            return;
        }
        temp = temp->next;
    }

    Console::puts("ContframePool::release_frames - Cannot release frame. Frame not found in frame pools.\n");
    assert(false);
}

void ContFramePool::release_frames_in_pool(unsigned long _first_frame_no)
{
    unsigned long idx = _first_frame_no - base_frame_no;

    if (get_state(idx) != FrameState::HoS){
        Console::puts("FrameState not in HoS\n");
        assert(false);
    }

    // Free HoS
    set_state(idx, FrameState::Free);
    nFreeFrames++;
    idx++;

    // Free subsequent Used frames
    while (idx < nframes){
        FrameState st = get_state(idx);

        if (st == FrameState::Free || st == FrameState::HoS)
            break;

        set_state(idx, FrameState::Free);
        nFreeFrames++;
        idx++;
    }
}

unsigned long ContFramePool::needed_info_frames(unsigned long _n_frames)
{	
	// Since we use 2 bits per frame, each byte can hold states for 4 frame
	return ( (_n_frames / (4*FRAME_SIZE) ) + (_n_frames % (4*FRAME_SIZE) > 0 ? 1 : 0 ));
}
