# Utilities for thread pool - create, destroy, and execute tasks in round-robin fashion

# Create a thread pool with the given number of worker threads
# and the given script to execute in each worker thread
# return the threa ids of the worker threads
proc create_thread_pool {worker_count script} {
  set pool [list]
  for {set i 0} {$i < $worker_count} {incr i} {
    set thread_id [thread::create]
    thread::send $thread_id $script
    lappend pool $thread_id
  }
  return $pool
}

# Load the given script to the worker threads in the given pool
proc load_script_to_pool {pool script {async 1}} {
  foreach thread $pool {
    if {$async} {
      thread::send -async $thread $script
    } else {
      thread::send $thread $script
    }
  }
}

proc destroy_thread_pool {pool} {
  # Send exit cmd to each worker thread in the pool
  foreach thread $pool {
    thread::release $thread
  }
}

# Wait for all the worker threads in the pool to finish
proc wait_for_pool_to_finish {pool} {
  # send empty script in syncronous mode to each worker thread
  foreach thread $pool {
    thread::send $thread {}
  }
}

# return the next worker thread in the round-robin fashion from the given `pool`
proc thread_round_robin_generator {pool} {
  set i 0
  while {1} {
    yield [lindex $pool $i]
    set i [expr {($i + 1) % [llength $pool]}]
  }
}
