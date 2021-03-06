package semantics.timed.simultaneous

import semantics.common.Context
import timedfsm.fsm.Fork
import timedfsm.fsm.Join
import timedfsm.fsm.StateMachine
import timedfsm.fsm.Transition
import java.util.ArrayList
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList

import static extension semantics.timed.simultaneous.StateAspect.*
import static extension semantics.timed.simultaneous.StateMachineAspect.*
import static extension semantics.timed.simultaneous.TransitionAspect.*

//
// *.*
// Auxiliary class
/**
 * Class for executing events in parallel. 
 */
class SimultaneousEventsThread extends Thread {
	
	String event
	StateMachine stateMachine
	Context context
	ArrayList<timedfsm.fsm.State> currentState
	ArrayList<Transition> currentTransitions
	
	/**
	 * Constructor of the class. Initializes the attributes with the values
	 * in the parameters
	 */
	new (String _event, StateMachine _stateMachine, Context _context){
		event = _event
		stateMachine = _stateMachine
		context = _context
		currentState = new ArrayList<timedfsm.fsm.State>()
		currentTransitions = new ArrayList<Transition>()
	}
	
	/**
	 * Runs the thread!
	 */
	override run(){
		var EList<timedfsm.fsm.State> attendedStates = new BasicEList<timedfsm.fsm.State>()
		
		for(timedfsm.fsm.State _state : stateMachine.currentState){
			for(Transition transition : _state.outgoing){
				if(transition.trigger !== null && 
					transition.trigger.expression.equals(event)){
					currentState.add(_state)
				}
			}
		}
		
		for(timedfsm.fsm.State _state : currentState){
			for(Transition transition : _state.outgoing){
				if(transition.trigger.expression.equals(event)){
					attendedStates.add(_state)
					currentTransitions.add(transition)
				}
			}
		}
		
		currentState.removeAll(attendedStates)
		stateMachine.removeCurrentStates(attendedStates)
		processTransitions(context)
	}
	
	/**
	 * Processes the current active transitions by activating their target states
	 * and executing the steps on the states (should the evaluation of the states be called from here?). 
	 */
	def private void processTransitions(Context context){
		
		// Fork: If the current transition goes to a Fork, we need to jump to the corresponding events; 
		//			there are neither guards nor triggers
		for(Transition _transition : currentTransitions){
			
			_transition.process(context)
			
			if(_transition.target instanceof Fork){
				var ArrayList<ForkThread> threads = new ArrayList<ForkThread>()
				for(Transition _forkTransition : _transition.target.outgoing){
					currentState.add(_forkTransition.target)
					stateMachine.currentState.add(_forkTransition.target)
					var ForkThread _forkThread = new ForkThread(_forkTransition.target, context);
					threads.add(_forkThread)
					_forkThread.start
				}
				
				var boolean threadsAlive = true
				while(threadsAlive){
					var int stillAlive = 0
					for(Thread _thread : threads){
						if(_thread.alive){stillAlive++}
					}
					if(stillAlive == 0)threadsAlive=false
				}
			}else{
				
				// Simple state: If the transition goes to a simple state, evaluate the state and add it to the current states.  
				currentState.add(_transition.target)
				stateMachine.currentState.add(_transition.target)
				_transition.target.eval(context)
			}
		}
		
		// Join: If the current state is followed by a Join, we need to jump to it.
		//		there are neither guards nor triggers in this kind of situation. 
		var EList<timedfsm.fsm.State> toAdd = new BasicEList<timedfsm.fsm.State>()
		var EList<timedfsm.fsm.State> toRemove = new BasicEList<timedfsm.fsm.State>()
		
		for(timedfsm.fsm.State _state : currentState){
			if(_state.outgoing.size() > 0 && _state.outgoing.get(0).target instanceof Join){
				
				if(!toAdd.contains(_state.outgoing.get(0).target) && 
					!currentState.contains(_state.outgoing.get(0).target))
					toAdd.add(_state.outgoing.get(0).target)
					
				if(!toRemove.contains(_state))
					toRemove.add(_state)
			}
		}
		currentState.removeAll(toRemove)
		currentState.addAll(toAdd)
		stateMachine.removeCurrentStates(toRemove)
		stateMachine.addCurrentStates(toAdd)
	}
}