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

# Destroy the given thread pool
proc destroy_thread_pool {pool} {
  # Send exit message to each worker thread
  foreach thread $pool {
    thread::send $thread {exit}
  }
  # # Wait for each worker thread to exit
  # foreach thread $pool {
  #   thread::join $thread
  # }
}

# return the next worker thread in the round-robin fashion from the given `pool`
proc thread_round_robin_generator {pool} {
  set i 0
  while {1} {
    yield [lindex $pool $i]
    set i [expr {($i + 1) % [llength $pool]}]
  }
}
