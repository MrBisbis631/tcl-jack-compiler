# experiment with threasd pool

source "[file normalize .]/utils/imports.tcl"

set workers 3

set script {
  proc handler {message} {
    puts "I'm thread [thread::id] and my message is: $message"
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
