# experiment with threasd pool

source "[file normalize .]/utils/imports.tcl"

set workers 5

set script {
  puts "I'm thread [thread::id] with script 1"

  proc handler {message} {
    puts "I'm thread [thread::id] and my message is: $message"
  }
}

set script_2 {
  puts "I'm thread [thread::id] with script 2"

  proc handler_2 {message} {
    puts "I'm also [thread::id] and my message is: $message"
  }
}

# init a thread pool thith thread ids
set pool [create_thread_pool $workers $script]
# init a corutine that returns the workers in round-robin
coroutine round_robin_coroutine thread_round_robin_generator $pool

for {set index 0} {$index < 15} {incr index} {
  # Scadule tasks `handler` from `script` asyncronusly to the workers in the thread pool
  thread::send -async [round_robin_coroutine] [list handler "printing $index"]
}

# wait for all the tasks to finish
wait_for_pool_to_finish $pool

# add another script to the pool
load_script_to_pool $pool $script_2

for {set index 0} {$index < 15} {incr index} {
  # Scadule tasks `handler_2` from `script_2` asyncronusly to the workers in the thread pool
  thread::send -async [round_robin_coroutine] [list handler_2 "showing $index"]
}

destroy_thread_pool $pool

# kill all existing threads
# thread::broadcast exit
