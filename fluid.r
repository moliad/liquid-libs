rebol [
	; -- Core Header attributes --
	title: "fluid | liquid dialect"
	file: %fluid.r
	version: 1.0.5
	date: 2013-10-26
	author: "Maxim Olivier-Adlhoch"
	purpose: {Creates and simplifies management of liquid networks.}
	web: http://www.revault.org/modules/fluid.rmrk
	source-encoding: "Windows-1252"
	note: {slim Library Manager is Required to use this module.}

	; -- slim - Library Manager --
	slim-name: 'fluid
	slim-version: 1.2.1
	slim-prefix: none
	slim-update: http://www.revault.org/downloads/modules/fluid.r

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
		v1.0.0 - 2013-10-04
			-Creation of fluid
			-Basic dialect mapped out.
			-Plug creation done
			-Core plug type creation done (currently only dependency mode)
			-Plug linking done

		v1.0.1 - 2013-10-09
			-Graph subdialect completed
			-Container creation
			-Plug references

		v1.0.2 - 2013-10-14
			-Linking enhanced to support chain linking.
			-Basic Piping done.
			-Inline expressions
			-Added FETCH() function
			-Added EXTEND-GRAPH()
			-Inline expressions now allow an optional graph directly.
			-Inline functors (Function references are now converted to plug instances on the fly)
	
		v1.0.3 - 2013-10-16
			-added sub graph linking on plug references (not just new plugs) within graph dialect
			-changed a few rules to simplify them.
			-added internal 'PUSH and 'POP functions,
			-GRAPH-STACK is now part of library directly, instead of being within 'FLOW function
	
		v1.0.4 - 2013-10-18
			-Many bug fixes.
		
		v1.0.5 - 2013-10-26
			-added context merging support with the /using keyword.
			-context merging now supports paths
	}
	;-  \ history

	;-  / documentation
	documentation: {
		Fluid is a quick and dirty dialect to manage Liquid dataflow networks.
		
		For now, the documentation is rough and expects a basic understanding of liquid and dataflow in general.
		
		If you look at fluid code, it might look a bit like normal Rebol code, but it's actually quite different.
		
		Fluid mostly sets up the dataflow graph, it doesn't actually compute it.  Some parts of the dialect might
		force a computation, but that is not the norm.
	}
	;-  \ documentation
]



;--------------------------------------
; unit testing setup
;--------------------------------------
;
; test-enter-slim 'fluid
;
;--------------------------------------

slim/register [

	slim/open/expose 'liquid none [ !plug liquify content fill link attach detach unlink plug? pipe piped? ]
	slim/open/expose 'utils-words none [ as-lit-word ]
	slim/open/expose 'utils-blocks none [ popblk: pop ]
	
	
	;--------------------------
	;-     fluids:
	;
	;  catalogue of known plug classes for use in  flow
	;--------------------------
	fluids: none 
	
	
	;--------------------------
	;-     --init--()
	;--------------------------
	; purpose:  
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	--init--: funcl [
		;lib
		/extern fluids
	][
		vin "--init--()"
		catalogue !plug
		
		vout
		
		true
	]
	
	
	
	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- PARSE RULES
	;
	;-----------------------------------------------------------------------------------------------------------
	
	.tmp: none
	
	=fail=: [end skip] ; cannot skip end!
	=gt=: as-lit-word >
	=lt=: as-lit-word <
	=|=:  as-lit-word |
	
	=using=: [ /USING ]
	
	=set-issue-fail?=: none
	=set-issue=: [
		(=set-issue-fail?=: none) 
		set .tmp issue! 
		( if #":" <> last .tmp [ =set-issue-fail?=: =fail= ] )
		=set-issue-fail?=
	] 
	
	
	
	
	
	
	
	
	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- FUNCTIONS
	;
	;-----------------------------------------------------------------------------------------------------------
	
	
	
	
	;--------------------------
	;-     to-catalogue()
	;--------------------------
	; purpose:  given one or more plug classes, returns a selectable context (or map!)
	;
	; inputs:   block of plugs
	;
	; returns:  object!
	;
	; notes:    If it finds words in the block it tries to get their value... these must be bound to a context
	;           and refer to a !plug
	;
	;           If you suply a plug with a valve/type which is already in catalogue, we use the new one.
	;
	; tests:    
	;--------------------------
	to-catalogue: funcl [
		plugs [block! object!]
	][
		vin "to-catalogue()"
		
		plugs: compose [(plugs)]
		catalogue: copy []
		
		foreach plug plugs [
			all [
				any [
					object? plug
					all [
						word? plug
						object? plug: get plug
					]
				]
				in plug 'valve
				in plug 'liquid
				word? type: select plug/valve 'type
				append catalogue reduce [ to-set-word type plug ]
			]
		]
		
		catalogue: context catalogue
		
		;---
		; show what plugs are part of catalogue
		vprobe words-of catalogue
		
		vout
		catalogue
	]
	
	
	
	;--------------------------
	;-     catalogue()
	;--------------------------
	; purpose:  given a plug, will add it to global fluid catalogue
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	catalogue: funcl [
		plug [object!]
		/extern fluids
	][
		vin "catalogue()"
		fluids: make any [fluids context []] to-catalogue plug
		vprobe mold words-of fluids
		vout
		fluids
	]
	
	
	
	
	;--------------------------
	;-     to-fluid-error()
	;--------------------------
	; purpose:  raises a fluid type error.
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    for now its just a stub for to-error
	;
	; tests:    
	;--------------------------
	to-fluid-error: funcl [
		msg [string! block!]
	][
		vin "to-fluid-error()"
		
		if block? msg [
			msg: rejoin msg
		]
		
		to-error msg
		vout
	]
	
	
	;--------------------------
	;-     probe-graph()
	;--------------------------
	; purpose:  
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	probe-graph: funcl [
		graph-ctx [ object! ]
		/debug
	][
		vin/always "probe-graph()"
		foreach word words-of graph-ctx [
			switch/default word [
				*catalogue [
					vprint/always ["*** graph catalogue: " mold words-of select graph-ctx '*catalogue ]
				]
			][
				vprint/always [ "" word " (" get in get in (plug: get in graph-ctx word) 'valve 'type ":" plug/sid"): " mold content plug ]
			]
		]
		vout/always
	]
	
	
	
	
	;--------------------------
	;-     extend-gctx()
	;--------------------------
	; purpose:  extends a graph context with a new word, if it doesn't already contain it.
	;
	; inputs:   object! & word! 
	;            
	;
	; returns:  If the context already contains that word, the same context is returned (unless /always is used)
	;
	; notes:    /fill automatically creates a !plug if plug type is new...
	;           /with is usually mutually exclusive to /fill, but they do work together (given a special pipe maste).
	;
	; tests:    
	;--------------------------
	extend-gctx: funcl [
		ctx [object!]
		property [any-word!]
		/fill value "give it a value immediately."
		/with plug "a plug is given explicitely"
		/always "always create a new context, even if it already contains the given word"
	][
		vin "extend-gctx()"
		set-property: to-set-word property
		property: to-word property
		
		if any [
			always
			not in ctx property
		][
			vprint "allocating new graph"
			ctx: make ctx reduce [
				set-property none
			]
		]
		
		if with [
			set in ctx property plug
		]
		
		if fill [
			unless plug: plug? get in ctx property [
				vprobe type? :plug
				vprint "allocating new plug!"
				set in ctx property (plug: liquify !plug )
				;probe-graph ctx
			]
			plug/valve/fill plug :value
		]
		vout
		ctx
	]
	
	
	
	;--------------------------
	;-     fetch()
	;--------------------------
	; purpose:  tries to get the given word from given graph, or directly from word binding, if its not in graph
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	fetch: funcl [
		word [any-word!]
		graph [object!]
		/plug "only retrieves plug values, returns none if value are not a plug"
	][
		vin "fetch()"
		;word: to-word word
		
		vprobe word
		
		value: any [
			select graph word
			get word
		]
		
		if plug [
			value: plug? :value
		]
		
		vout
		
		:value
	]
	
	
	;--------------------------
	;-     push()
	;--------------------------
	; purpose:  quick stub to push observer on stack
	;
	; inputs:   a plug to put on the stack
	;
	; returns:  the given plug
	;--------------------------
	push: funcl [
		plug [object!]
	][
		vin [ "push(" plug/valve/type ":" plug/sid ")" ]
		append graph-stack plug
		vout
	]
	
	
	
	;--------------------------
	;-     pop()
	;--------------------------
	; purpose:  removes plugs from top of stack, 
	;
	; inputs:   
	;
	; returns:  removed plug
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	pop: funcl [][
		vin "pop()"
		plug: popblk graph-stack
		vprint [ "(" plug/valve/type ":" plug/sid ")" ]
		vout
		plug
	]
	
	


	
	;--------------------------
	;-     graph-stack:
	;
	; stores the current =graph= rule processing stack
	;
	; it is cleared at each flow execution in case any errors left the stack dangling.
	;--------------------------
	graph-stack: []
	
	
	
	
	;--------------------------
	;-     flow()
	;--------------------------
	; purpose:  the main entry point for interpretation of fluid dialect blocks
	;
	; inputs:   block! of fluid
	;
	; returns:  context with plugs and values.
	;
	; notes:    although we return a context which has a reference to (some) of the plugs by name. we still use the 'SET
	;           word internally, which may use words bound to any context.  the return object, is more a courtesy for 
	;           tracking what happened within.  You may use some refinements to alter how this is managed.
	;
	;           The graph is executed as it is encoutered, in the order it is encountered.  if an error occurs beyond
	;           some (potential) very basic verification, you can assume that the graph is unstable.
	;
	;           note that if you supply plugs which exist outside the graph and link them or link to them, any error will
	;           effectively leave some dangling links and may potentioally break your app.
	;
	;           using /safe mode, you may be able to effectively recover from an error, since all nodes created from within
	;           this flow session will be unlinked and destroyed before raising an error (within appropriate msg).
	;
	;           current implementation is not optimised for speed but rather maintainability and bug prevention.
	;           at some point, parts of the implementation will be replaced for speed-ups.
	;
	;           do not prefix any of your name with '! or '* as these are reserved internally and will end up in the result context.
	;
	;           /WITHIN must be treated carefully: if giving one context, it is used directly, and might replace plugs inside.
	;           if you give a block of contexts, a new internal context is created with all the provided contexts merged.
	;           This means that although flow() may connect the plugs from the context you gave it... it will not be able to
	;           REPLACE the plugs within the provided context.  if you must do this, use the return graph and adjust your 
	;           context directly.
	;
	;           Furthermore, when using /WITHIN there must **ONLY** be plugs inside any provided user-ctx.
	;           if you provide a context with anything else inside, you are crossing the UNDEFINED and UNSUPPORTED side.
	;          
	; tests:    
	;--------------------------
	flow: funcl [
		graph [block!]
		/contain "Do not use SET on words, only use a private internal context (independent of /within)"
		/using selection [ block!  ] "Give an (initial) plug class selection directly. (just a list of !plug classes), this is in addition to the global selection."
		/within user-ctx [ object! block! ] "provide one or more context to set plugs within... if words are missing in context, a new context is created and extended"
		/safe "Upon error, destroy all new nodes automatically"
		/debug "changes return object to a !DEBUG-CTX object.  the normal return object will be within debug-ctx/rval"
	][
		vin "flow()"
		
		vprobe graph
		clear head graph-stack
		
		catalogue: any [
			all [
				using
				make fluids to-catalogue selection 
			]
			
			make fluids [] ; default catalogue, copied on each run, because we may modify it.
		]
		
		
		;---
		; graph context, used for tracking what occured.
		;
		; there may be a few extra words created by the flow algorithm, these will be prefixed
		;
		; new classes are prefixed with a '!  character (so don't use them in your names!)
		;---
		gctx: any [
			user-ctx
			context []
		]
		vprint [ "catalogue: " mold words-of catalogue ]
		vprint [ "graph ctx: " mold words-of gctx ]
		
		
		;---
		; debug context
		dbg-ctx: context [
			leaves:  [] ; plugs with no subordinates.
			roots:   [] ; plugs with no observers.
			classes: [] ; any classes created within the fluid graph
			
			return-val: context [] ; what would have been returned if /debug had not been used.
		]
		
		

		
		;-         =graph=:
		; this is a hierarchichal rule which allocates and links things including anonymous plugs.
		;
		; the rule may call itself (so care must be taken in handling blocks).
		;
		; the stack will be dangling when an error occurs but that's not a big deal. The reason being that
		; we halt on error and clear the stack on any new attempt.
		;
		; We REQUIRE a .observer to be set BEFORE calling =graph= 
		;
		; note that since the block is not modified at each run (no compose or reduce) the rule itself doesn't
		; add any processing to the function, but its content is effectively bound to the function.
		;---
		=graph=: [
			; (append stack .observer)
			(vin "found graph")
			some [
				[
					[
						set .word word! (
							vprint "link?"
							unless .subordinate: fetch/plug .word gctx [
								to-fluid-error [ "word " .word " does not reference a plug" ]
							]
							vprint ["found plug to link to (" .subordinate/valve/type ":" .subordinate/sid ")"]
							
							;---
							; we push plug on the stack, in case it has a sub graph to link to.
							;
							; the stack popping will actually do the link.
							;
							; if there is no subgraph, no harm is done as it will be popped immediately.
							push .observer
							.observer: .subordinate
						)
					]
					| [
						(.word: none)
						opt [ set .word set-word! ]
						set .pclass issue! 
						(
							push .observer
							.pclass: to-word rejoin ["!" .pclass]
							
							either p: select catalogue .pclass [
								vprint "allocating new plug"
								v?? .pclass
								plug: .observer: liquify p
								if set-word? .word [
									vprint ["will add plug to graph "  ]
									gctx: extend-gctx/with gctx .word plug
								]
							][
								to-fluid-error [ "Plug type ("  ") not found" "... near: ^/ " mold copy/part here 3] 
							]
						)
					]
				]
				opt [ into =graph= ]
				(
					vprint "Ready to link"
					.subordinate: .observer
					.observer: pop
					
					link .observer .subordinate
					;if debug [ probe-graph gctx ]
					vprint ["done linking observer (" .observer/valve/type ":" .observer/sid ") to subordinate (" .subordinate/valve/type ":" .subordinate/sid ")"]
				)
			]
			(vout)
		]
		
		
		=new-plug=: [
			set .word set-word!
			
		]
		
		
		
		parse graph [
			some [
				(vprint "-------------")
				here:
							
				;----
				;-         creating plug
				[
					set .word set-word! 
					set .pclass issue! 
					(
						vin "creating plug."
						.pclass: to-word rejoin ["!" .pclass]
						v?? .word
						v?? .pclass
						
						either p: select catalogue .pclass [
							vprobe type? :p
							plug: .observer: liquify p
							gctx: extend-gctx/with gctx .word plug 
							
							;if debug [ probe-graph gctx ]
						][
							to-fluid-error [ "Plug type ("  ") not found" "... near: ^/ " mold copy/part here 3] 
						]
						
						;if debug [ probe-graph gctx ]
					)
					opt [into =graph=] 
					(vout)
				]
				
				;----
				;-         create reference to an existing plug
				| [
					set .ref set-word! 
					set .plug get-word!
					(
						vin "creating reference."
						unless plug? any [
							select gctx .plug
							get .plug
						][
							to-fluid-error ["Cannot create plug reference... " .plug " is not a liquid plug" ]
						]
						gctx: make gctx vprobe reduce  [
							.ref .plug 
						]
						;if debug [ probe-graph gctx ]
						vout
					)
				]
				
				;----
				;-         assign value of a word to a (possibly new) plug
				| [
					; if the .word given is a plug, we get its content and fill it within the new plug.
					; note that data is not copied. if that is required, insert a #copy plug.
					set .plug-name set-word! 
					set .value word!
					(
						vin "Assign a word's value to a plug."
						=post-value-rule=: none
						.value: fetch :.value gctx 
						vprint type? :.value
						switch/default type?/word :.value [
							function! native! action! [
								vprint "FUNCTOR"
								.observer: liquify processor/safe '!functor-fluid :.value
								
								gctx: extend-gctx/with gctx .plug-name  .observer
								
								=post-value-rule=: [ opt  [into =graph=] ]
							]
						][
							either plug? :.value [
								vprint "value is a plug"
								.value: content .value
								vprint ["value is of type: " type? :.value]
								
							][
								vprint ["value is of type: " type? :.value]
							]
	
							gctx: extend-gctx/fill gctx .plug-name .value
						]
						
						;if debug [ probe-graph gctx ]
						vout
					)
				]
				=post-value-rule=
				

				;----
				;-         inline class expression
				| [
					set .plug-name set-word! 
					set .expression paren!
					(
						vin "inline class expression."
						.observer: liquify processor '!inline-fluid to-block .expression
						gctx: extend-gctx/with gctx .plug-name  .observer
					)
					opt  [into =graph=] 
					(
						;if debug [ probe-graph gctx ]
						vout
					)
				]				
				
				
				
				;----
				;-         creating or setting container
				| [
					set .word set-word! 
					set .value skip
					(
						vin "creating or setting container."
						either plug? :.value [
							.value: content .value
							vprint ["value is a plug with value: " mold :.value]
						][
							vprint ["value has value: " mold :.value]
						]
						
						gctx: extend-gctx/fill gctx .word .value
						;if debug [ probe-graph gctx ]
						vout
					)
				]
				
				;----
				;-         create new plug class
				| [
					set .class =set-issue=
					set .code block!
					(
						vin "CREATING NEW PLUG CLASS."
						.class: to-word head remove back vprobe tail rejoin [ "!" .class ]
						v?? .class
						catalogue: make catalogue vprobe reduce [
							to-set-word .class 'processor to-lit-word .class .code
						]
						vprint ["Catalogue: " mold words-of catalogue]
						;if debug [ probe-graph gctx ]
						vout
					)
				]
				
				;----
				;-         linking plugs
				| [
					set .observer word!
					some [
						=lt=
						set .subordinate word!
						(
							vin "LINKING PLUGS"
							either all [
								any [
									object? .observer
									.observer:    select gctx .observer
								]
								.subordinate: select gctx .subordinate
							][
								vprint ["linking " .observer/valve/type " to " .subordinate/valve/type ]
								link .observer .subordinate
							][
								to-fluid-error "plug doesn't exist"
							]
							.observer: .subordinate
							;if debug [ probe-graph gctx ]
							vout
						)
					]
				]
				
				
				;----
				;-         piping plugs
				;
				; note that the first plug's value is kept.
				| [
					(pserver: none )
					set .pipe-server word!
					some [
						=|=
						here: 
						set .pipe-client word!
						(
							vin "piping plug"
							either pclient: plug? any [
								fetch .pipe-client gctx
							][
								vprint ["pipe client: (" pclient/valve/type ":" pclient/sid ")" ]
								;---
								; generate pipe from the plug
								unless pserver [
									either pserver: plug? any [
										select gctx .pipe-server
										fetch .pipe-server gctx
									][
										unless piped? pserver [
											pipe/only pserver
										]
									][
										to-fluid-error [ "Piping allows only plug references: " copy/part here 5 ]
									]
								]
								vprint ["pipe server: (" pserver/valve/type ":" pserver/sid ")" ]
								either pserver [
									attach pclient pserver
								][
									to-fluid-error [ "Piping first item to be pipe server: " copy/part here 5 ]
								]
							][
								to-fluid-error [ "Piping allows only plug references: " copy/part here 5 ]
							]
							vout
						)
					]
				]
				
				
				;----
				;-         merging contexts (graphs)
				| [
					=using=
					(vprint "USING?:")
					here: 
					set .context [ object! | path! | word! ]
					(
						vin "Merging context"
						vprobe type? :.context
						
						either all [
							attempt [
								switch type?/word .context [
									object! [
										ctx: .context
									]
									
									path! [
										path: .context
										all [
											not function? get first path
											object? ctx: do path
										]
									]
									
									word! [
										ctx: fetch .context gctx
									]
								]
							]
							object? ctx
							not empty? words: words-of ctx
						][
							v?? words
							foreach word words [
								either plug? value: get word [
									gctx: extend-gctx/with gctx word :value
								][
									gctx: extend-gctx/fill gctx word :value
								]
							]
						][
							to-fluid-error "/USING:   Given value does not refer to a context"
						]
						vout
					)
				]
				;----
				;-         merging contexts (graphs)
				| [
					/PROBE-GRAPH
					( 
						;vprint "PROBE GRAPH" 
						probe-graph gctx
					)
				]
				
				
				; if there is something left... error
				| here: skip (
					to-fluid-error [ "Invalid flow... Here: " mold back new-line next new-line (back insert copy/part here 5 to-word ">>>" ) true false ]
				)
			]
		
		]
		
		vout
		
		.observer: .subordinate: .class: .code: .value: .word: .plug-name: .expression: .ref: .plug: .pclass: none
		p: plug: user-ctx: selection: graph: here: pclient: pserver: .pipe-server: .pipe-client: .context: none
		
		first reduce either debug [[
			make gctx [
				*catalogue: make catalogue []
			]
			gctx: catalogue: none	
		]][[
			gctx
			gctx: catalogue: none
		]]
	]
]

;------------------------------------
; We are done testing this library.
;------------------------------------
;
; test-exit-slim
;
;------------------------------------

