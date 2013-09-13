REBOL [
	; -- Core Header attributes --
	title: "Glue | core liquid plug types.  "
	file: %glue.r
	version: 0.1.1
	date: 2013-9-10
	author: "Maxim Olivier-Adlhoch"
	purpose: "liquid plugs for use in any liquified app."
	web: http://www.revault.org/modules/glue.rmrk
	source-encoding: "Windows-1252"
	note: {slim Library Manager is Required to use this module.}

	; -- slim - Library Manager --
	slim-name: 'glue
	slim-version: 1.2.1
	slim-prefix: none
	slim-update: http://www.revault.org/downloads/modules/glue.r

	; -- Licensing details  --
	copyright: "Copyright © 2013 Maxim Olivier-Adlhoch"
	license-type: "Apache License v2.0"
	license: {Copyright © 2013 Maxim Olivier-Adlhoch

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.}

	;-  / history
	history: {
		v0.1.1 - 2013-9-10 (MOA)
			-license change to Apache v2}
	;-  \ history

	;-  / documentation
	documentation: {
		This is a collection of reusable liquid !plugs which handle many low-level things 
		within any liquid using apps.
		
		All the plugs defined here are permanent and will never be removed. if we ever break-up glue into smaller
		parts, Glue will still include a reference to the plugs so that you don't need to refurbish code.
	}
	;-  \ documentation
]





;--------------------------------------
; unit testing setup
;--------------------------------------
;
; test-enter-slim 'glue
;
;--------------------------------------

slim/register [
	liquid-lib: slim/open/expose 'liquid none [ !plug processor ]
	liquid-lib: slim/open/expose 'liquid none [fill content link attach liquify !plug pipe unlink]

	
	
	;-------------------------------
	;-     !construct[]
	;
	; given a block, calls construct on it.
	;-------------------------------
	!construct: processor '!construct  [
		vin "!construct/process()"
		;vprobe data
		plug/liquid: all [
			obj: pick data 1
			
			; uniformitize input into a block
			obj: any [
				all [ string? obj load obj ]
				obj
			]
			block? obj
			attempt [ construct obj ]
		]
		;vprobe obj
		vout
	]
	
	
	
	


	
	
	;------------------------------
	;-     !length[p]
	;
	;  given data, returns its length
	;
	;  inputs:
	;
	;    dataset:  any length?-able value.
	;    
	;  output:
	;    length of input
	;
	;  notes:
	;    because of the inherintly low-level nature of this plug, we do not do any error checking
	;    beyond recieving input.
	;
	;------------------------------
	!length: processor '!length [
		plug/liquid: any[
			attempt [length? pick data 1]
			0
		]
	]
	
	
	;------------------------------
	;-     !op[p]
	;
	;  given data, applies a function to each value, storing each result as the operand for the next pass.
	;
	;  inputs:
	;
	;    series of scalar values. (should usually always be of the same type)
	;    
	;  output:
	;    length of input
	;
	;  notes:
	;    because of the inherintly low-level nature of this plug, we do not do any error checking
	;    beyond receiving input.
	;
	;    supplying incompatible data inputs WILL CAUSE AN ERROR!
	;
	;------------------------------
	!op: processor/with 'op [
		plug/liquid: pick data 1 0
		operation: get in plug 'operation
		foreach item next data [
			plug/liquid: operation plug/liquid item
		]
	][
		; set this to any function you need within your class derivative.
		;
		; note that operation is bound when the class is created, so you cannot
		; change it live, it will not react.
		operation: :add
	]


	;------------------------------
	;-     !divide[p]
	;
	;  a preset !op type
	;
	; just saves a bit of ram if it doesn't need to be re-defined at each instance.
	;
	;------------------------------
	!divide: make !op compose [operation: :divide valve: make valve[]]



	;------------------------------
	;-     !to-string
	;
	; note none is returned as "none"
	;------------------------------
	!to-string: processor '!to-string  [
		plug/liquid: to-string pick data 1
	]
	
	
	
	;------------------------------
	;-     !fast-add:
	;
	; fast and safe addition with as little code as possible.
	;------------------------------
	!fast-add: processor  '!fast-add  [
		plug/liquid: if 1 < length? data [
			add first data second data
		][0]
	]
		
		
	;------------------------------
	;-     !gate -->
	;
	;  returns a value only if some condition is met, returns none or a linked default otherwise. 
	;
	;  inputs:
	;
	;    this plug has different functionality, based on how many links it has!
	;
	;    	2) value: the value to pass    
	;          gate-switch: when condition matches the gate-switch value is passed
	;
	;    	3) value: the value to pass    
	;          trigger: when trigger satisfies mode, the value is passed.
	;          default:  this value is returned while trigger is invalid
	;
	;  output:
	;    the input value, none, or an optional default value.
	;
	;  notes:
	;    the plug has a mode which changes how the trigger is interpreted.
	;
	;------------------------------
	!gate: processor/with 'gate [
		value: pick data 1
		trigger: pick data 2
		default: any [pick data 3 plug/default-value] ; if nothing specified, this ends up being none.
		
		plug/liquid: switch plug/mode [
			if [
				either trigger [value][default]
			]
			true [
				either trigger = true [value][default]
			]
			not [
				either not trigger [value][default]
			]
			none [
				either trigger = none [value][default]
			]
			equal [
				either trigger = value [value][default]
			]
			different [
				either trigger <> value [value][default]
			]
		]
	][	
		;-         mode:
		mode: 'if ; if ,true, not, none, equal, different
		
		;-         default-value:
		; you can provide a static default, when creating links is not practical
		default-value: none
		
	]
	
	
	
	;------------------------------
	;-     !latch[p]
	;
	; this is a very special Plug which tampers with usual messaging on purpose
	;
	; it basically acts like a double coil latching relay.
	; 
	; you can use it directly to detect when some input plugs have changed since a manual reset.
	;
	; mode
	; ----
	;   it must ALWAYS be used in linked-container mode
	;
	; inputs
	; ----
	;    1: the change trigger [any!] whenever this link changes, the output switches to triggered until reset by a fill.
	;
	; optional inputs:
	; ----
	;    it may have one or two optional inputs 
	;    	2: value when data is triggered
	;
	;       3: value when node is reset
	;
	; functioning:
	; ----
	;    as opposed to other nodes, this one doesn't propagate to children when inputs change each time.
	;    it only propagates when the plug goes from one state to another (triggered, reset)
	;
	;    Any dirty call which is sent from the first link will switch plug to triggered state.
	;
	;    To reset the node, simply fill-it with a value which is different than the last time you filled it.
	;    a random number is a good trigger value.
	;
	; note:
	; ---- 
	;    doesn't support stainless? mode
	;
	;    this node allows liquid to actually break cycles in propagation, since only the first dirty will ever traverse. it doesn't
	;    cure instigation cycles though.
	;
	;    this is one of the nodes which really illustrate how flexible and powerfull liquid's api architecture really is.
	;    since it changes the messaging model while still being 100% compatible to other plugs.
	;
	;------------------------------
	!latch: make !plug [
	
		resolve-links?: true
	
		;-         previous-reset:
		previous-reset: none
		
		
		;-         changed?:
		changed?: none
		
		;-         valve[]
		valve: make valve [
			type: 'latch
	
			;---------------------
			;-             dirty()
			;---------------------
			; react to our link and fill being set to dirty.
			;
			;---------------------
			dirty: funcl [
				plug "plug to set dirty" [object!]
				/always "do not follow stainless? as dirty is being called within a processing operation.  prevent double process, deadlocks"
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/dirty()"]
				
				; this node doesn't support being stainless.
				
				link-dirty?: if sub: pick plug/subordinates 1  [
					get in sub 'dirty?
				]
				
				; dirty caused by fill
				either plug/previous-reset <> plug/mud [
					plug/changed?: false
					plug/previous-reset: plug/mud
					propagate/dirty plug
				][
					;dirty caused by link update
					if all[
						link-dirty?
						not plug/changed?
					][
						plug/changed?: true
						propagate/dirty plug
					]
				]
				
				; clean up
				plug: none
				vout
			]
			
			
			process: func [plug data][
			
				vin "glue/latch/process()"
				
				plug/liquid: case [	
					4 = length? data [pick next next data plug/changed?]
					3 = length? data [if plug/changed? [third data]]
					true [plug/changed?]
				]
				vout
			]
		]
	]
	
		
	;-     !merge[]
	;
	; simply returns a all inputs accumulated into one single block.
	; 
	;
	; inputs:
	;    expects to be used linked... doesn't really make sense otherwise
	;
	;    any data can be linked except for unset!
	;    block inputs are merged into a single block, but their block contents aren't.
	;
	;  so:
	;     [[111] [222] 333 [444 555 [666]]]  
	;
	;  becomes:
	;     [111 222 333 444 555 [666]]
	;
	;
	; note that chaining !merge plugs will preserve these un merged blocks in an indefinite
	; number of sub links, because the liquid is a block.
	; 
	; ex using the above:
	;     [ [111 222 333 444 555 [666]]  [111 222 333 444 555 [666]] ]
	;
	; becomes:
	;     [ 111 222 333 444 555 [666]  111 222 333 444 555 [666] ]

	!merge: processor '!merge [
		vin ["merge[" plug/sid "]/process()"]
		; we reuse the same block at each eval (saves series reallocation & GC overhead)
		plug/liquid: clear any [plug/liquid copy []]
		
		foreach item data [
			append plug/liquid :item
		]
		vout
	]
	
	
	
	
	;--------------------------
	;-     !select -->
	;--------------------------
	; purpose:  launches select on input serie! or object!
	;
	; inputs:   
	;     item:  a word to get/select in context.
	;     collection: an object or block of word/value pairs
	;
	; returns:  the result of SELECT, NONE if an error occured.
	;
	; notes:    
	;   -using this as a linked container makes a lot of sense.
	;    just change the plug/resolve-links? to be 'LINK-BEFORE or LINK-AFTER so that you can link either context or value to
	;
	;	-NONE transparent 
	;	
	; tests:    
	;--------------------------
	!select: processor '!select [
		vin ["!select[" plug/sid "]/process()"]
		plug/liquid: all [
			item: pick data 1
			collection: pick data 2
			attempt [
				select collection item
			]
		]
		vout
	]
	
	
	
	
	
	;--------------------------
	;-     !pick -->
	;--------------------------
	; purpose:  picks in a series, safe if inputs are invalid
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    none transparent
	;
	; tests:    
	;--------------------------
	!pick: processor '!pick [
		vin ["!pick[" plug/sid "]/process()"]
		plug/liquid: ;all [
			;series? series: pick data 1
			;scalar? index:  pick data 2  ; not completely fail safe, but handles the majority of cases.
			attempt [
				pick first data second data
			]
		;]
		vout
	]
	


	
	;--------------------------
	;-     !get-in-ctx -->
	;--------------------------
	; purpose:  launches select on input serie! or object!
	;           has an extra plug value to allow you to preset the attribute to select
	;
	; inputs:   
	;     context:    an object or block of word/value pairs
	;     attribute:  a word to get/select in context.
	;
	;     if filled, the value is the attribute to extract
	;
	; returns:  the result of SELECT or NONE if an error occured.
	;
	; notes:    
	;   -using this as a linked container makes a lot of sense.
	;    just change the plug/resolve-links? to be 'LINK-BEFORE or LINK-AFTER so that you can link either context or attribute to extract
	;
	;	-NONE transparent 
	;	
	; tests:    
	;--------------------------
	!get-in-ctx: processor/with '!get-in-ctx [
		vin ["!get-in-ctx[" plug/sid "]/process()"]
		;vprobe plug/attribute
		plug/liquid: all [
			collection: pick data 1
			item: any  [pick data 2   plug/attribute]
			attempt [
				select collection item
			]
		]
		vout
	][
		resolve-links?: 'LINK-BEFORE
		attribute: none
	]


		
	
]

;------------------------------------
; We are done testing this library.
;------------------------------------
;
; test-exit-slim
;
;------------------------------------

