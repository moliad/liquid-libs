rebol [
	; -- Core Header attributes --
	title: "fluid | liquid dialect"
	file: %fluid.r
	version: 1.1.0
	date: 2013-11-14
	author: "Maxim Olivier-Adlhoch"
	purpose: {Creates and simplifies management of liquid networks.}
	web: http://www.revault.org/modules/fluid.rmrk
	source-encoding: "Windows-1252"
	note: {slim Library Manager is Required to use this module.}

	; -- slim - Library Manager --
	slim-name: 'fluid
	slim-version: 1.2.2
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
			
		v1.0.6 - 2013-10-30
			- auto-memorize capabilities added
			- renamed 'CATALOGUE function to 'MEMORIZE
			- 'MEMORIZE function now allows block! type input
			- internal value 'FLUIDS renamed 'MODELS
			- renamed fluids-index to models-index
		
		v1.0.7 - 2013-11-01
			- all references to graphs in code are renamed POOLS.
			- issues now create new models if they are not in catalogue, using global function of the same name, if it exists.
			  before you'd get an error that the plug class (model) didn't exist.
			- 'EXTEND-GRAPH/'EXTEND-GCTX  renamed to 'INCORPORATE
			- 'MODELIZE function added.  uniformitizes creation of new models based on different input datatypes.
			  handles the auto-memorize flag so it simplies code it dialect.
			  it also automatically grows the given catalogue, if any.
			  
		v1.0.8 - 2013-11-07
			- /SHARING is now supported in 'FLOW dialect, similar to /USING but shares plugs back into original context.
			- 'RESERVED? function added.
			- 'INCORPORATE now requires either /fill or /with .  will raise an error otherwise.
			- gctx/*catalogue renamed to gctx/+catalogue
			- 'RETRIEVE-CTX function added
			- added +shared  to gctx, to store shared contexts
			
		v1.0.9 - 2013-11-13
			-/Remodel keyword allow you to mutate plugs on the fly
			-the < linking operation now accepts a block in order to link several plugs at once.
	
		v1.1.0 - 2013-11-14
			- /SHARING now allows a prefix which is added to pool names, but remembers original names.
			  allows to import several contexts with the same words, and yet make them all distinct in the pool.
			- Note that with all the new functionality added in the last few versions, a major revision bump was in order.
			- A lot of debugging vprints are still left, since fluid is still under review and intensive design.
	}
	;-  \ history

	;-  / documentation
	documentation: {
		Fluid is a quick and dirty dialect to manage Liquid dataflow networks.
		
		For now, the documentation is rough and expects a basic understanding of liquid and dataflow in general.
		
		If you look at fluid code, it might look a bit like normal Rebol code, but it's actually quite different.
		
		Fluid mostly sets up the dataflow graph, it doesn't actually compute it.  Some parts of the dialect might
		force a computation, When this is the case, it will be explicitely documented.
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

	slim/open/expose 'liquid 1.3.4 [ !plug liquify content fill link attach detach unlink plug? liquid? pipe piped? ]
	slim/open/expose 'utils-words none [ as-lit-word ]
	slim/open/expose 'utils-blocks none [ popblk: pop ]
	
	
	
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
	][
		vin "--init--()"
		memorize !plug
		
		vout
		
		true
	]
	
	

	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- GLOBALS
	;
	;-----------------------------------------------------------------------------------------------------------
	;--------------------------
	;-     models:
	;
	;  internal, global catalogue of known plug models for use in flow
	;--------------------------
	models: none 


	;--------------------------
	;-     pool-stack:
	;
	; stores the current =pool= rule processing stack
	;
	; it is cleared at each flow execution in case any errors left the stack dangling.
	;--------------------------
	pool-stack: []


	;--------------------------
	;-     auto-memorize?:
	;
	; when true, all new plug (labeled) models are memorized
	;--------------------------
	auto-memorize?: none
	
	




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
	;- CATALOGUE FUNCTIONS
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
	;-     memorize()
	;--------------------------
	; purpose:  given a plug object or block of plugs, will add it to global fluid catalogue
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	memorize: funcl [
		"given a plug object or block of plugs, will add it to global fluid catalogue"
		plug [object! block!]
		
		/extern models
	][
		vin "memorize()"
		models: make any [models context []] to-catalogue plug
		vprobe mold words-of models
		vout
		models
	]
	
	
	;--------------------------
	;-     auto-memorize()
	;--------------------------
	; purpose:  tells fluid to automatically memorize all plug models created in all flows from this point on.
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	auto-memorize: funcl [
		/extern auto-memorize?
	][
		vin "auto-memorize()"
		auto-memorize?: true
		vout
	]
	
	
	;--------------------------
	;-     models-index()
	;--------------------------
	; purpose:  gives list of plugs names in models catalogue
	;
	; inputs:   none
	;
	; returns:  block of words
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	models-index: funcl [][
		vin "models-index()"
		vout
		words-of models
	]
	
	
	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- POOL MANAGEMENT
	;
	;-----------------------------------------------------------------------------------------------------------
	
	;--------------------------
	;-     modelize()
	;--------------------------
	; purpose:  easily creates plug models based on different input types 
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    - when given a [ function! block! paren! type ]  it uses !inline-fluid as the plug name and never memorizes it.
	;           - we take care of memorization, if auto-memorize? is on
	;
	; tests:    
	;--------------------------
	modelize: funcl [
		model [word! issue! function! block! paren!]
		'catalogue [word! none!]
		/name model-name "this is mainly used to replace the function! type model name default, other types take the input data as the name."
	][
		vin "modelize()"
		
		vprobe type? catalogue
		
		;ask "!"
		
		
		switch/default type?/word :model [
			word! [
				model-name: any [ 
					model-name 
					to-word rejoin ["!" model ]
				]
				code: get model
			]
			
			issue! [
				model-name: any [
					model-name 
					to-word rejoin ["!" model ]
				]
				code: get to-word to-string model
				unless any-function? :code [
					to-fluid-error rejoin ["Cannot modelize " mold model ",  '" model " must refer to a function"]
				]
			]
			
			paren! [
				code: to-block model
			]
		][
			code: :model
		]
		
		model-name: any [
			model-name
			'!inline-fluid
		]
		
		v?? model-name
		vprint type? model
		model: processor model-name :code
		
		if all [
			auto-memorize? 
			model-name <> 'inline-fluid
		][
			memorize model
		]
		
		if all [
			catalogue
			model-name <> 'inline-fluid
		][
			set catalogue make get catalogue reduce [
				to-set-word model-name model 
			]
		]
		
		vout
		
		model
	]



	;--------------------------
	;-     incorporate()
	;--------------------------
	; purpose:  extends a pool context with a new word, if it doesn't already contain it.
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
	incorporate: funcl [
		ctx [object!]
		property [any-word!]
		/fill value "give it a value immediately."
		/with plug [object!] "a plug is given explicitely"
		/always "always create a new context, even if it already contains the given word"
	][
		vin "incorporate()"
		set-property: to-set-word property
		property: to-word property
		
		if any [
			always
			not in ctx property
		][
			vprint "allocating new pool"
			ctx: make ctx reduce [
				set-property none
			]
		]
		
		if all [
			with 
			liquid? plug
		][
			set in ctx property plug
		]
		
		if fill [
			unless plug: liquid? get in ctx property [
				vprobe type? :plug
				vprint "allocating new plug!"
				set in ctx property (plug: liquify !plug )
				;probe-pool ctx
			]
			plug/valve/fill plug :value
		]
		
		; if plug is shared in another context, set it.
		if shared-prop: find ctx/+shared property [
			
			either all [
				lit-word? orig-name: pick back shared-prop 1
				object? shared-ctx: pick next shared-prop 1
			][
				set in shared-ctx orig-name plug
			][
				v?? orig-name
				v?? property
				vprobe type? shared-ctx
				v?? shared-ctx
				vdump ctx/+shared
				to-fluid-error "incorporate(): pool's shared list is corrupted!"
			]
		]
		vout
		ctx
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
		append pool-stack plug
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
		plug: popblk pool-stack
		vprint [ "(" plug/valve/type ":" plug/sid ")" ]
		vout
		plug
	]
	

	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- HELPER FUNCTIONS
	;
	;-----------------------------------------------------------------------------------------------------------


	;--------------------------
	;-     probe-pool()
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
	probe-pool: funcl [
		pool-ctx [ object! ]
		/debug
	][
		vin/always "probe-pool()"
		
		;vdump pool-ctx
		
		;vprint "============="
		foreach word words-of pool-ctx [
			switch/default word [
				+catalogue [
					vprint/always ["*** pool catalogue: " mold words-of select pool-ctx '+catalogue ]
				]
				+shared [
					vprint/always ["*** shared plugs: "   mold extract next pool-ctx/+shared 3 ]
				
				]
			][
				;vprint word
				vprint/always [ "" word " (" (
					get in (
						get in (
							plug: get in pool-ctx word
							;vprint "PLUG:"
							;vdump plug
						) 'valve
					) 'type 
				) ":" plug/sid"): " mold content plug ]
			]
		]
		vout/always
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
	;-     fetch()
	;--------------------------
	; purpose:  tries to get the given word from given pool, or directly from word binding, if its not in pool
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
		pool [object!]
		/plug "only retrieves plug values, returns none if value are not a plug"
	][
		vin "fetch()"
		;word: to-word word
		
		vprobe word
		
		value: any [
			select pool word
			get word
		]
		
		if plug [
			value: plug? :value
		]
		
		vout
		
		:value
	]
	
	
	
	;--------------------------
	;-     reserved?()
	;--------------------------
	; purpose:  determines if a word is a reserved word
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	reserved?: funcl [
		word [word!]
	][
		vprint [ "reserved?(" word ")" ]
		#"+" = first to-string word
	]
	
	
	
	;--------------------------
	;-     retrieve-ctx()
	;--------------------------
	; purpose:  given some data, try to retrieve a context if it points to one
	;
	; inputs:   object! path! or word!
	;
	; returns:  an object or none
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	retrieve-ctx: funcl [
		pool [object!]
		key [ object! word! path! ]
	][
		vin "retrieve-ctx()"
		ctx: all [
			attempt [
				switch type?/word key [
					object! [
						ctx: key
					]
					
					path! [
						path: key
						all [
							not any-function? get first path
							object? ctx: do path
						]
					]
					
					word! [
						ctx: fetch key pool
					]
				]
			]
			object? ctx
			not empty? words: words-of ctx
			ctx
		]
		
		v?? words

		key: words: path: pool: none
		vout
		ctx
	]
	
	
	
	
	
		
	
	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- DIALECTS
	;
	;-----------------------------------------------------------------------------------------------------------

	
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
	;           The pool is executed as it is encoutered, in the order it is encountered.  if an error occurs beyond
	;           some (potential) very basic verification, you can assume that the pool is unstable.
	;
	;           note that if you supply plugs which exist outside the pool and link them or link to them, any error will
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
	;           REPLACE the plugs within the provided context.  if you must do this, use the return pool and adjust your 
	;           context directly.
	;
	;           Furthermore, when using /WITHIN there must **ONLY** be plugs inside any provided user-ctx.
	;           if you provide a context with anything else inside, you are crossing the UNDEFINED and UNSUPPORTED side.
	;          
	; tests:    
	;--------------------------
	flow: funcl [
		pool [block!]
		/contain "Do not use SET on words, only use a private internal context (independent of /within)"
		/using selection [ block!  ] "Give an (initial) plug model catalogue. (just a list of !plug classes), this is in addition to the global selection."
		/within user-ctx [ object! block! ] "provide one or more context to set plugs within... if words are missing in context, a new context is created and extended"
		/safe "Upon error, destroy all new nodes automatically"
		/debug "changes return object to a !DEBUG-CTX object.  the normal return object will be within debug-ctx/rval"
		/extern models
	][
		vin "flow()"
		
		vprobe pool
		clear head pool-stack
		
		catalogue: any [
			all [
				using
				make models to-catalogue selection 
			]
			
			make models [] ; default catalogue, copied on each run, because we may modify it.
		]
		
		
		;---
		;-     GCTX
		; pool context, used for tracking what occured.
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
		vprint [ "pool ctx: " mold words-of gctx ]
		
		
		gctx: make gctx [
			
			;--------------------------
			;-         shared:
			;
			; A list of plugs we are sharing with other contexts...
			;
			; whenever these are created, we have to set them in their respective contexts too.
			;
			; a good example is for use in glass.  materials are created manually, so sharing them
			; with a flow means the materials will be generated directly.
			;--------------------------
			+shared: [
				; plug-name  context-ref
			]
		]
		
		
		vdump gctx
		
		
		;---
		; debug context
		dbg-ctx: context [
			leaves:  [] ; plugs with no subordinates.
			roots:   [] ; plugs with no observers.
			classes: [] ; any classes created within the fluid pool
			
			return-val: context [] ; what would have been returned if /debug had not been used.
		]
		
		

		
		;-         =pool=:
		; this is a hierarchichal rule which allocates and links things including anonymous plugs.
		;
		; the rule may call itself (so care must be taken in handling blocks).
		;
		; the stack will be dangling when an error occurs but that's not a big deal. The reason being that
		; we halt on error and clear the stack on any new attempt.
		;
		; We REQUIRE a .observer to be set BEFORE calling =pool= 
		;
		; note that since the block is not modified at each run (no compose or reduce) the rule itself doesn't
		; add any processing to the function, but its content is effectively bound to the function.
		;---
		=pool=: [
			; (append stack .observer)
			(vin "found pool")
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
							; we push plug on the stack, in case it has a sub pool to link to.
							;
							; the stack popping will actually do the link.
							;
							; if there is no subpool, no harm is done as it will be popped immediately.
							push .observer
							.observer: .subordinate
						)
					]
					| [
						(.word: none)
						opt [ set .word set-word! ]
						set .model issue! 
						(
							push .observer
							.model: to-word rejoin ["!" .model]
							
							either p: select catalogue .model [
								vprint "allocating new plug"
								v?? .model
								plug: .observer: liquify p
								if set-word? .word [
									vprint ["will add plug to pool "  ]
									gctx: incorporate/with gctx .word plug
								]
							][
								to-fluid-error [ "Plug type ("  ") not found" "... near: ^/ " mold copy/part here 3] 
							]
						)
					]
				]
				opt [ into =pool= ]
				(
					vprint "Ready to link"
					.subordinate: .observer
					.observer: pop
					
					link .observer .subordinate
					;if debug [ probe-pool gctx ]
					vprint ["done linking observer (" .observer/valve/type ":" .observer/sid ") to subordinate (" .subordinate/valve/type ":" .subordinate/sid ")"]
				)
			]
			(vout)
		]
		
		
		parse pool [
			some [
				(vprint "-------------")
				here:
							
				;----
				;-         creating plug
				[
					set .word set-word! 
					set .issue issue! 
					(
						vin "creating plug."
						
						.model: to-word rejoin ["!" .issue]
						v?? .word
						v?? .model
						
						either p: any [
							select catalogue .model 
							modelize .issue catalogue
						][
							vprobe type? :p
							plug: .observer: liquify p
							gctx: incorporate/with gctx .word plug 
							
							;if debug [ probe-pool gctx ]
						][
							to-fluid-error [ "Plug type ("  ") not found" "... near: ^/ " mold copy/part here 3] 
						]
						
						;if debug [ probe-pool gctx ]
					)
					opt [into =pool=] 
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
						;if debug [ probe-pool gctx ]
						vout
					)
				]
				
				;----
				;-         assign value of a word to a (possibly new) plug
				| [
					; if the .word given is a plug, we get its content and fill it within the new plug.
					; note that data is not copied. if that is required, insert a #copy plug.
					set .plug-name set-word! 
					set .word word!
					(
						vin "Assign a word's value to a plug."
						=post-value-rule=: none
						value: fetch .word gctx 
						vprint type? :value
						switch/default type?/word :value [
							function! native! action! [
								vprint "FUNCTOR"
								plug-model-name: either auto-memorize? [
									to-word rejoin ["!" .word ]
								][
									'!functor-fluid
								]
								
								plug-model: processor/safe plug-model-name :value
								
								.observer: liquify plug-model

								if auto-memorize? [
									memorize plug-model
								]							
								
								gctx: incorporate/with gctx .plug-name  .observer
								
								=post-value-rule=: [ opt  [into =pool=] ]
							]
						][
							either plug? :value [
								vprint "get plug content and fill it in new plug"
								value: content value
								vprint ["value is of type: " type? :value]
							][
								vprint ["value is of type: " type? :value]
							]
	
							gctx: incorporate/fill gctx .plug-name value
						]
						
						;if debug [ probe-pool gctx ]
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
						gctx: incorporate/with gctx .plug-name  .observer
					)
					opt  [into =pool=] 
					(
						;if debug [ probe-pool gctx ]
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
						
						gctx: incorporate/fill gctx .word .value
						;if debug [ probe-pool gctx ]
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
						;if debug [ probe-pool gctx ]
						vout
					)
				]
				
				;----
				;-         linking plugs
				| [
					here:
					set .observer word!
					some [
						=lt=
						set .subordinate [ word! | block! ]
						(
							vin "LINKING PLUGS"
							subordinates: compose [(.subordinate)]
							foreach .subordinate subordinates [
								either all [
									any [
										; reuse last plug in chained linking (a < b < c )
										object? .observer
										
										; or assign observer to the first plug in the list.
										.observer:    select gctx .observer
									]
									liquid? .subordinate: fetch/plug .subordinate gctx
								][
									;vprint ["linking " .observer/valve/type " to " .subordinate/valve/type ]
									vprint ["linking observer (" .observer/valve/type ":" .observer/sid ") to subordinate (" .subordinate/valve/type ":" .subordinate/sid ")"]
									link .observer .subordinate
								][
									to-fluid-error ["cannot link, data does not refer to liquified plug, here: "  mold copy/part here 4]
								]
								.observer: .subordinate
							]
							;if debug [ probe-pool gctx ]
							vout
						)
						here:
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
				;-         importing contexts (pools)
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
							;v?? words
							foreach word words [
								unless (reserved? word) [
									either plug? value: get word [
										gctx: incorporate/with gctx word :value
									][
										gctx: incorporate/fill gctx word :value
									]
								]
							]
						][
							to-fluid-error "/USING:   Given value does not refer to a context"
						]
						vout
					)
				]
				
				
				;----
				;-         sharing contexts (pools)
				;
				; the difference here is that any plug created on the fly, is also set 
				; within the original context.
				| [
					/SHARING
					(vprint "SHARING?:")
					here: 
					set .prefix opt tag!
					set .context [ object! | path! | word! ]
					(
						vin "SHARING context"
						if ctx: retrieve-ctx gctx .context [
							vprobe "we can share a pool."
							vprobe type? ctx
							words-of ctx
							foreach src-word words-of ctx [
								v?? src-word
								word: either .prefix [
									to-word rejoin ["" to-string .prefix "." src-word ]
								][
									src-word
								]
								v?? word
								
								;---
								; check if the word (possibly prefixed) is already used
								; in our pool
								either shared: find/tail gctx/+shared word [
									vprint "REPLACE SHARE"
									change shared ctx
								][
									vprint "ADD SHARE"
									;-----------------------
									; ** ATTENTION **
									;
									; the to-lit-word is ESSENTIAL.   this is because FIND
									; is able to differentiate between word and lit-words.
									;
									; on the other hand, the 'IN function (in context [a: 1] first ['a] )
									; doesn't differentiate.  so the incorporate function can find and set 
									; the original name from its context using our local name... without any
									; type conversion.
									;-----------------------
									append gctx/+shared reduce [ to-lit-word src-word  word  ctx ]
								]
								
								;---
								; use or create new plug
								either liquid? value: get src-word [
									gctx: incorporate/with gctx word :value
								][
									gctx: incorporate/fill gctx word :value
								]
							]
						][
							to-fluid-error "/SHARING:   Given value does not refer to a context"
						]
						vout
					)
				]



				;----
				;-         remodeling
				| [
					/remodel 
					set .plug-name word! 
					set .model-spec [ issue!  |  word!  |  paren!  | block!  ]
					(
						vin "remodeling plug."
						v?? .plug-name
						v?? .model-spec
						
						model: switch type?/word :.model-spec [
							issue! [
								any [
									select catalogue model-name: to-word rejoin [ "!" .model-spec ]
									fetch/plug model-name gctx
								]
							]
						
							word! [
								fetch/plug .model-spec gctx
							]
							
							paren! block! [
								modelize .model-spec
							]
						]
						
						
						unless plug? model [
							to-fluid-error [ "Plug type (" .model-spec ") not found" "... near: ^/ " mold copy/part here 3] 
						]
						
						vprint ["model type: " model/valve/type ]
						 
						unless plug: plug? fetch/plug .plug-name gctx [
								to-fluid-error [ "Invalid plug name given, plug doesn't exist in pool : ^/ " mold copy/part here 3] 
						]
					
						plug/valve: model/valve
						vout
					)
				]
				



				
				
				;----
				;-         inline probing of pools
				| [
					/PROBE-POOL
					( 
						vprint "PROBE POOL" 
						probe-pool gctx
					)
				]
				
				
				; if there is something left... error
				| here: skip (
					to-fluid-error [ "Invalid flow... Here: " mold back new-line next new-line (back insert copy/part here 5 to-word ">>>" ) true false ]
				)
			]
		
		]
		
		vout
		
		.observer: .subordinate: .class: .code: .value: .word: .plug-name: .expression: .ref: .plug: .model: none
		p: plug: user-ctx: selection: pool: here: pclient: pserver: .pipe-server: .pipe-client: .context: none
		
		first reduce either debug [[
			make gctx [
				+catalogue: make catalogue []
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

