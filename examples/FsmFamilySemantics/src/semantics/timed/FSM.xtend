package semantics.timed

import semantics.common.Context
import timedfsm.fsm.Fork
import timedfsm.fsm.InitialState
import timedfsm.fsm.Join
import timedfsm.fsm.State
import timedfsm.fsm.StateMachine
import timedfsm.fsm.Transition
import fr.inria.diverse.k3.al.annotationprocessor.Aspect
import java.util.ArrayList
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList

import static extension semantics.timed.StateAspect.*
import static extension semantics.timed.TransitionAspect.*

//
// *.*
// ASPECT
/**
 * StateMachineAspect: Aspects for the State Machine meta-class
 * Serves as the interpreter of the state machine (the controller of the )
 */
@Aspect(className=StateMachine)
class StateMachineAspect {
	
	EList<State> currentState = null
	EList<Transition> currentTransitions = null
	
	/**
	 * Evaluates the input and sequentially executes the steps in the state machine. 
	 */
	 
	def public void eval (Context context, String filePath) {
		println("\nExecuting the state machine. Please wait for the results...\n")
		println(" ... executing input ...\n")
		
		var ArrayList<EList<String>> events = context.events
		
		_self.currentState = _self.getInitialState()
		_self.currentState.get(0).eval(context)
		
		for(EList<String> eventsGroup : events){
			println("  input item: " + eventsGroup + " time: " + (System.currentTimeMillis as int))
			_self.step(context, eventsGroup)
		}
		
		println("\n *.* Your results are ready! \n")
		(new Printer()).printFinalStateInConsole(_self)
		(new Printer()).printFinalStateInFile(_self, filePath)
	}
	
	/**
	 * Performs a step in the state machine i.e., reads an entry of the input stack and executes it.
	 * If there are several events in the same step they are executed sequentially.  
	 */
	def private void step(Context context, EList<String> eventsGroup){
		// In this case, the current transitions are local to the step. 
		_self.currentTransitions = new BasicEList<Transition>()
		var ArrayList<State> attendedStates = new ArrayList<State>()
		
		for(String event : eventsGroup){
			for(State _state : _self.currentState){
				for(Transition transition : _state.outgoing){
					if(transition.trigger.expression.equals(event)){
						attendedStates.add(_state)
						_self.currentTransitions.add(transition)
					}
				}
			}
			_self.currentState.removeAll(attendedStates)
		}
		_self.processTransitions(context)
	}
	
	/**
	 * Processes the current active transitions by activating their target states
	 * and executing the steps on the states (should the evaluation of the states be called from here?). 
	 */
	def private void processTransitions(Context context){
		
		// Fork: If the current transition goes to a Fork, we need to jump to the corresponding outgoing states; 
		//			there are neither guards nor triggers
		for(Transition _transition : _self.currentTransitions){
			
			_transition.process(context)
			
			if(_transition.target instanceof Fork){
				var ArrayList<ForkThread> threads = new ArrayList<ForkThread>()
				for(Transition _forkTransition : _transition.target.outgoing){
					_self.currentState.add(_forkTransition.target)
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
				_self.currentState.add(_transition.target)
				_transition.target.eval(context)
			}
		}
		
		// Join: If the current state is followed by a Join, we need to jump to it.
		//		there are neither guards nor triggers in this kind of situation. 
		var ArrayList<State> toAdd = new ArrayList<State>()
		var ArrayList<State> toRemove = new ArrayList<State>()
		
		for(State _state : _self.currentState){
			if(_state.outgoing.size() > 0 && _state.outgoing.get(0).target instanceof Join){
				
				if(!toAdd.contains(_state.outgoing.get(0).target) && 
					!_self.currentState.contains(_state.outgoing.get(0).target))
					toAdd.add(_state.outgoing.get(0).target)
					
				if(!toRemove.contains(_state))
					toRemove.add(_state)
			}
		}
		
		_self.currentState.removeAll(toRemove)
		_self.currentState.addAll(toAdd)
	}
	
	/**
	 * Returns the (unique?) initial state of the state machine. 
	 */
	def private EList<State> getInitialState(){
		var answer = new BasicEList<State>()
		for(State state : _self.states){
			if(state instanceof InitialState) answer.add(state)
		}return answer
	}
}


@Aspect(className=State)
class StateAspect {
	
	def public void eval(Context context) {
		_self.initialTime = (System.currentTimeMillis) as int
		Context.stateWorking(1000)
		_self.finalTime = (System.currentTimeMillis) as int
	}
}

@Aspect(className=Transition)
class TransitionAspect {
	def public void process(Context context) {
		Context.stateWorking(_self.time)
	}
}