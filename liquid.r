REBOL [
	; -- Core Header attributes --
	title: "liquid | dataflow management "
	file: %liquid.r
	version: 1.3.3
	date: 2013-10-21
	author: "Maxim Olivier-Adlhoch"
	purpose: {Dataflow processing kernel.  Supports many computing modes and lazy programming..}
	web: http://www.revault.org/modules/liquid.rmrk
	source-encoding: "Windows-1252"
	note: {slim Library Manager is Required to use this module.}

	; -- slim - Library Manager --
	slim-name: 'liquid
	slim-version: 1.2.1
	slim-prefix: none
	slim-update: http://www.revault.org/downloads/modules/liquid.r

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
		v0.0.1 - 0.5.0
			-several years of prototyping different dataflow systems.
			-eventually combined into one codebase
			-eventually merged into A SINGLE base class (out from 4 different & incompatible base classes)
			-adding of caching, low-level linking, propagation, processing levels.
			-cycle detection algorythm testing
			-several stub functions now officially part of api.
		
		v0.5.1
			-finalise new piping and mud mechanism
			
		v0.5.2
			-link()/exlusive implementation
	
		v0.5.3
			-add /as to liquify
			
		v0.5.4
			-add stats method to valve.
			-fully test and enable labeled mode for linking
			-add valve/links/labels
			-add valve/links/labeled
			-finish block optimisation in instigate returning all subordinate values directly.
			
		v0.5.5 - 24-Apr-2006/13:13:13
			-added disregard
			-rebuilt unlink using disregard (cause v0.5.4 didn't unlink observers! MAJOR BUG)
			-link() should return an error when trying to link a pipe server using /label (not likely, but for advanced users this must be explicitely disallowed)
			-support multiple plugs per label
	
		v0.5.6 - 26-Apr-2006/11:14:34
			-added /fill refinement to liquify
	
		v0.5.7 - 27-Apr-2006/3:35:39
			-removed all double comments (;;) from code
			-improved comments on valve/setup and explicitely state that we can call link at that point.
			-added valve/sub()
			-cycle? now officially part of miscelaneous methods
			-added /link refinement to liquify
	
	
		v0.5.8 - 29-Apr-2006/14:31:40
			-verbose is now off by default, from now on.
	
	
		v0.5.9 - 29-Apr-2006/15:02:55
			-fix dirty? state return valur of purify.
			-fixed propagate as a result of above fix
	
	
		v0.5.10 - 24-May-2006/17:07:43
			-added category to valve.  helps in classification.
			-removed init as default startup state, easy to forget and invalidates dirtyness by default..
			 better let the user toggle it on knowingly  :-)
	
		v0.5.11 - 5-Oct-2006/2:27:14
			-renamed plug! to !plug (no clash with real types)
			-officially added !node alias to !plug (to ease adoption)
			-liquify/link properly support single plug! spec (it used to support only a block of plugs)
			-added linked-container? attribute to !plug
			-fill now creates a container (simple pipe) rather than a pipe (linked pipe) by default.
			-added word! clash protection on link labels, so that instigate code can separate labels from actual word! type data (not 100% fault tolerant, but with documentation, it becomes easy to prevent).
	
		v0.5.12 - 17-Oct-2006/11:58:09
			-license switch to MIT
	
		v0.5.13 - 20-Oct-2006/5:31:44
			-attach() pipe linking method
			-detach() pipe unlinking method
			-added support for a block! of subordinates in link utility func.
	
		v0.6.0 - 1-Nov-2006/11:19:29 (MOA)
			-quick release cleanup.
			-version major
	
		v0.6.1 - 27-Nov-2006/15:01:40 (MOA)
			-added pipe function, with optional /with refinement.  makes piping more explicit.
			-fixed linked-container? mode handling here and there.
	
		v0.6.2 - 12-Dec-2006/22:35:25 (MOA)
			-fixed a rare linking setup, when you supply none! as the subordinate to create orphaned links.
	
	
		v0.6.3 - 12-Dec-2006/22:55:18 (MOA)
	
	
		v0.6.4 - 4-Feb-2007/7:01:06 (MOA)
			-adding the commit feature.  vastly simplifying many plug uses.
			-not yet implemented commit, but layed out the design for future compatibility.
	
	
		v0.6.5 - 19-Feb-2007/22:35:54 (MOA)
	
		v0.6.5 - 13-Apr-2007/19:02:42 (MOA)
	
		v0.6.6 - 13-Apr-2007/19:02:58 (MOA)
	
		v0.6.7 - 20-Apr-2007/2:59:58 (Unknown)
	
		v0.6.8 - 29-Apr-2007/7:55:52 (Unknown)
	
		v0.6.9 - 30-Apr-2007/16:56:30 (Unknown)
			-added insubordinate method.
			-added /with refinement to liquid
	
		v0.6.10 - 30-Apr-2007/22:07:40 (Unknown)
			-now clears sid in destroy (extra mem cleanup)
	
		v0.6.11 - 11-May-2007/0:46:56 (Unknown)
			-added reset refinement to link and valve/link
	
		v0.6.14 - 11-Jul-2007/19:46:17 (MOA)
	
		v0.6.15 - 15-Jul-2007/0:58:46 (Unknown)
	
	
		v0.6.17 - 16-Jul-2007/22:57:02 (MOA)
	
		v0.7.0 - 7-Mar-2009/00:54:04(MOA)
			-added PIPE-SERVER-CLASS functionality to ease custom pipe management
			-fixed minor fill bug related to binding in rebol sub-objects
			
		v0.7.1 - 8-Mar-2009/05:54:04(MOA)
			-fixed regression in link() where a word was deleted from the code for some unknown reason, breaking the function on un-piped nodes.
			-added FROZEN? and related functionality. can be set to a function for powerfull dynamic node freezing.
			
		v0.7.2 - 8-Mar-2009/21:25:55(MOA)
			-officially deprecated and REMOVED SHARED-STATES from the whole module
			-ON-LINK() 
		
		v0.8.0 - 15-Mar-2009/00:00:00(MOA)
			-adding stream engine for propagation-style inter-node messaging.
			-STREAM() added for look-ahead messaging (ask observers to react to us)
			-ON-STREAM() added to support callbacks when a stream message arrives at a plug.
			
		v0.8.1 - 28-Mar-2009/00:00:00(MOA)
			-PROPAGATE?() added to valve - allows us to optimise lazyness in some advanced plugs
			-LINK?() regression found and fixed... cycle?() was not being used anymore!
			
		v0.8.2 - 02/04/2009/11:13PM(MOA)
			-the index? of returned instigate() block is now OFFICIALLY the insert position of the linked-container, if any.
			 this used to be an undefined aspect of liquid, but must now be explicitely handled in any
			 custom cleanup function.  This was added, since some plugs will need this at the head, while others
			 will need it at the tail, for processing consistency.
			 
		v0.8.3 - 04/04/2009/3:10AM (MOA)
			-fixed bug in CLEANUP() which didn't use path to access the instigate method.
			-fixed CYCLE?() bug which tripped over labeled links.
			-added optional PLUG/PREVIOUS-MUD attribute handling to fill, allows other funcs to detect if fill actually
			 changed value.
			-PLUG/PREVIOUS-MUD now set within CLEANUP(), so that multiple fills do not trigger events, until they have been used.
			-LINKED?() little improvements.
			
		v0.8.4 - 27/04/2009/10:37PM (MOA)
			-plug/mud is now an official store of pre-allocated series, which you do not want to reset (re-allocate) at each process()
			 no code change, but now an official specification.  so plug/mud is not changed by any function except fill() and related.
			 
		v0.8.5 - 03/05/2009/8:15AM (MOA)
			-added UNLINK() stub function
			
		v0.8.6 - 15/09/2009 6:27PM (MOA)
			-fixed ATTACH() regression which didn't set pipe? on pipe clients ... strange
			-added 'LIQUID-ERROR-ON-CYCLE? attribute to lib.  this tells liquid to raise an error if 
			 the LINK?() method detects a cycle?(). prevents unlinked plugs from being silently ignored
			 and causing frustrating errors (and hard to understand/debug).
			-Liquid now sets 'LIQUID-ERROR-ON-CYCLE? to true by default, so connection errors will result
			 in thrown errors... beware.
		
		v1.0.0 01/10/2010 (MOA)
			-removed ALL vprint-based debugging to dramatically increase performance. (only !plug/valve/stats remains with vprint).
			-as I am using this library in a publicly-released application for the first time, and because I've
			 been actively using liquid successfully in most projects for YEARS, I've decided to sign-off 
			 on an official reference v1 release.
			 
		v1.0.1 17/04/2010 (MOA)
			-optimised propagate so its ignored when a node is already dirty.
			-fixed cycle? so it starts at observer, instead of subordinate... fixes erronous cycle detections.
		
		v1.0.2 27/04/2010 (MOA)
			-bridge pipe server mode work started.
			-completely rebuilt attach and link functions.  they are faster and add bridge.
			-replace linked-container? by resolve-links? attribute. any pipe or container can now process as well as store.
			-fixed little shortcomings in destroy() and linked?()
			-half of the library is rewritten with optimisation for speed and bridge support throughout.
			-empiric unit-testing shows that changes have had a VERY positive effect on various aspects of liquid (alloc, process,etc).
			-added support for CHECK-CYCLE-ON-LINK?.  this is EXTREMELY advanced control of liquid, but makes an as extreme difference on allocation.
			 use it within controled systems which can clearly and properly manage the linkeage.  when building user guis or readable scripts,
			 make sure to use cycle? before linking, if cycle-check is off.
			-unit-testing & profiling
	
		v1.0.3 30/04/2010 (MOA)
			-bridge support testing and fixing.
			
		v1.0.4 12/05/2010 (MOA)
			-CHECK-CYCLE-ON-LINK? is now OFF BY DEFAULT
			-bridge mode finished
			-bug fixes in CLEANUP()
			-added /TO refinement to ATTACH() stub
			-added REINDEX-PLUG()
			-added FREEZE() and THAW() stubs
			
		v1.0.5 2010-06-23 (MOA)
			-added PROCESS()  stub
			-added BRIDGE() stub
			-added PLUG?() to determine if something is a liquid plug
			-added NOTIFY() valve method and stub
			-added /ONLY to valve/DETACH() and stub
			-added /PRESERVE to ATTACH() stub
			-removed most vprinting to accelerate library
		
		v1.1.0 2012-02-07 (MOA)
			-added concept of !default-plug.
			
		v1.1.1 2012-09-12 (MOA)
			-re-instated a few vprints
			-fixed PLUG/VALVE/FILL() when used on pipe clients... they don't get propagated back (it never gets dirty).
			
		v1.2.0	2012-11-07 (MOA)
			-Added FORMULATE()
			-Tweaked PROCESSOR(), which now uses FORMULATE()
			-Started to add unit tests using SLUT library.
			
		v1.2.1  2012-11-14 (MOA)
			-we can now control HOW link resolving is merged with the plug's mud (pipe or container).  See resolve-links? documentation for more details.
		
		v1.3.0 - 2013-06-20
			-added LINKED-MUD mode to resolve-links?, only usable by pipe-master, doesn't cause processing.
			-changed license to Apache v2
		
		v1.3.1 - 2013-10-11
			- 'PIPE() in external API now fills plug with value
			- 'PLUG?() now returns the plug itself instead of true
			- added new API method: PIPE? to detect if a plug is already a pipe server.
	
		v1.3.2 - 2013-10-17
			-MAJOR FIX to Pipe handling on Attach.  The pipe server now uses its own value as initial mud, 
			so that any cleanup receives the current value.  When a new pipe server is built, it uses the source's
			value for itself.
			
		v1.3.3 - 2013-10-21
			- process() api function is now officially deprecated, and renamed --process()
	}
	;-  \ history

	;-  / documentation
	documentation: {
		Liquid is a very low-level library which implements dataflow driven programming in REBOL.
		
		It supports advanced features like lazyness and on-the-fly mutation.
		
		The basic !plug implements the complete reference design and will actually allow you to
		switch computation methods on the fly.  This means that the same plug implements dependency
		bridging, containment, hold and modify, and data sharing.
		
		The online docs are where you should go to get all the details about using and 
		customizing liquid plugs.
	}
	;-  \ documentation
	to-do: {
		-----------------
		NOTE -  to do list is rarely up to date,
		-----------------
		-add more return values to functions like link, fill and connect, to allow interactive reactions to failed operations...
		-make ALL func tails (returns) GC friendly
		-once piped, a plug should not propagate dirty states, unless its pipe is dirty.  It should ignore any dirty
		 calls comming from its (temporarily useless) subordinates.
		-support label being present in subordinate list more than once (complements exclusive wrt labeled linking mode)
		-when attaching two piped plugs, add a callback to allow a pipe server to de-allocate itself safely when it 
		 detects it has no more pipe clients.
		
		** v2 proposals **
		-PUSH-MODE PROPAGATION OF PARAMETERS to all observers.
		 doesn't actually start processing, but distributes a set of values within a graph.
		-PROPAGATE ANY STATE, not just dirty. (ex: error), a subset of above
		-PARAMETER & CONTAINER INDEXED CACHING, caching of liquid is based on a key set of parameters, allowing us to
		 reload past processing!
		-CLASS-WIDE LINKS! all instances share links (allows VERY fast manipulation of global state without needing to 
		 link each instance separatly)
		-SUBORDINATE CONTAINMENT (like a fill, directly stored in subordinate block.)  allows us to simulate
		 a node which is connected to several subordinate containers, without the need to actually allocate any of them.
		
	}
]







;--------------------------------------
; unit testing
;--------------------------------------
; 
; test-enter-slim 'liquid
;
; test-init [ print "44" ]
; test-init [ print "55" ]
;
;
;
;
;
;
; test-preamble 'values  [   value-a: liquify/fill !plug 3   value-b: liquify/fill !plug 4   value-c: liquify/fill !plug   5]
; test-preamble 'sum-plug    <[
;	!sum-plug: make !plug [
;		valve: make valve [
;			process: funcl [plug data][
;				i: 0 foreach val data [  i: i + val  ] ; testing  a comment within the testing engine
;               ; another comment test
;				plug/liquid: i
;			]
;		]
;	]
; ]>
;
;
;
; test 'tprin [ print "test tprin" true]  ; this test has no preamble requirements
; test [add-3-7  sum-plug  liquid] [sum-plug  values] [ plug: liquify/link !sum-plug [value-a value-b]  probe content plug] ; this test requires preamble 'sum-plug and 'values
; test [add-4-5  sum-plug  liquid] [sum-plug  values] [ plug: liquify/link !sum-plug [value-a value-b]  probe content plug] ; this test requires preamble 'sum-plug and 'values
; test 'string-err-msg <[
;	print "a"
;   print "b"
;	"tadam"
; ]>  
; test 'unset-test [print "fofo"]
; test 'zdiv-error-test <[
;   0 / 0
; ]>  
;
;








;----
; use following line to determine real code size without comments.
;
; currently around 55 kb ! :-)  which means there is as much documentation and structure information within the source!!
;----
; write %stripped-liquid.r  entab replace/all "^^-" "^-"mold  load/header %liquid.r


slim/register [


	verbose: false

	; next sid to assign to any liquid plug.
	; and also tells you how many plugs have been registered so far.
	;-    liquid-sid-count:
	liquid-sid-count: 0


	;--------------------------
	;-    plug-list:
	plug-list: make hash! none
	
	
	;--------------------------
	;-    total-links:
	total-links: 0


	;--------------------------
	;-    liquid-error-on-cycle?:
	liquid-error-on-cycle?: true
	
	
	;--------------------------
	;-     !default-plug:
	;
	; this plus is used as the default by all api functions.
	;
	; you may override this in order to add custom functionality in all of your app.
	; note that you MUST NEVER overide the actual !plug word.
	;
	; always use !plug derivatives.
	;--------------------------
	!default-plug: none
	
	
	
	
	;--------------------------
	;-    check-cycle-on-link?:
	; this is used to control the cycle? check which is VERY slow on large networks.
	;
	; this should usually be set to true when debugging and developping, but once your code is robust and you can 
	; guarantee cycle? coherence, then it should be set to false, it will vastly improve linking speed.
	;
	; as such, cycle checks are the most demanding operations you can perform on a network of plugs.
	;
	; when set to false, you can still call cycle? manually on any plug.  which is a good thing for user-controled
	; linking verification.  but for the vast majority of links, where a program is handling the connections,
	; the cycle check isn't really needed.
	check-cycle-on-link?: false
	
	
	
	
			


	;-
	;------------------------------------------------------------------------------------------------------------------------------------------
	;- UTIL FUNCTIONS
	;------------------------------------------------------------------------------------------------------------------------------------------
	
;	;--------------------------
;	;-     extract-set-words()
;	;--------------------------
;	; purpose:  finds set-words within a block of code, hierarchically.
;	;
;	; inputs:   block!
;	;
;	; returns:  the list of words in set or normal word notation
;	;
;	; notes:    none-transparent
;   ;           (DEPRECATED using the version in slim)
;	;--------------------------
;	extract-set-words: func [
;		blk [block! none!]
;		/only "returns values as set-words, not ordinary words.  Useful for creating object specs."
;		/local words rule word
;	][
;		vin "extract-set-words()"
;		words: make block! 12
;		parse blk =rule=: [any [
;			set word set-word! (append words either only [word][to-word word]) |
;			hash! | into =rule= | skip
;		]]
;
;		vout
;		words
;	]

	
	
	
;	vin: vout: none	



	;--------------------------------------------------------------------------------------------------
	;- INTERNAL FUNCTIONS
	;--------------------------------------------------------------------------------------------------

	;-----------------------------------------
	;-    alloc-sid()
	;-----------------------------------------
	; currently the sid is a simple number, but
	; could become something a bit stronger in time,
	; so this allows us to eventually change the system without
	; need to change any plug generating code.
	;-----------------------------------------
	alloc-sid: func [][
		liquid-sid-count: liquid-sid-count + 1
	]


	;--------------------
	;-    retrieve-plug()
	;--------------------
	retrieve-plug: select-plug: func [
		"return the plug related to an sid stored in the global plug-list"
		sid
	][
		select plug-list sid
	]


	;--------------------
	;-    reindex-plug()
	; If a plug's object was modified, after allocation, the index still points to the old object.
	;
	; this allows us to do the following AFTER a call to liquify:
	;   plug: make plug [...]
	;
	; why?  some toolkits will allocate nodes pre-emptively and then allow an api to
	;       modify the allocated node directly, usually to add new values to the plug itself.
	;
	; if the plug isn't re-indexed, any call to retrieve-plug will still return the old
	; object, and the changes will seem to have vanished!
	;
	; note: It is an ERROR to call reindex-plug on a plug/sid which doesn't exist,
	;       either cause it was not yet intialized or was destroyed.
	;--------------------
	reindex-plug: select-plug: func [
		"replaces the object stored in the plug-list with this new one."
		new-plug
		/local old-plug list
	][
		either old-plug: select plug-list new-plug/sid [
			change find plug-list old-plug new-plug
		][
			to-error "LIQUID/Reindex() called on an unallocated node."
		]
	]


	;-----------------
	;-    freeze()
	;-----------------
	freeze: func [
		plug
	][
		vin [{freeze()}]
		
		plug/frozen?: true
		vout
	]
	
	
	;-----------------
	;-    thaw()
	;-----------------
	thaw: func [
		plug
	][
		vin [{thaw()}]
		
		plug/frozen?: false
		plug/valve/notify plug
		vout
	]
	
	
	
	
	

	;-
	;------------------------------------------------------------------------------------------------------------------------------------------
	;- EXTERNAL API !
	;------------------------------------------------------------------------------------------------------------------------------------------

	
	;-----------------------
	;-    liquify()
	;-----------------------
	liquify: func [
		type [object!] "Plug class object."
		/with spec "Attributes you wish to add to the new plug ctx."
		/as valve-type "shorthand to derive valve as an indepent from supplied type, this sets type/valve/type"
		/fill data "shortcut, will immediately fill the liquid right after its initialisation"
		/piped "since fill now makes containers by default, this will tell the engine to make it a pipe beforehand."
		/pipe "same as piped"
		/link plugs [block! object!]
		/label lbl [word!] "specify label to link to (no use unless /link is also provided)"
		/local plug
	][
		vin ["liquify('" type/valve/type ")"]
		spec: either none? spec [[]][spec]
		
		; unify plugs datatype
;		plugs: compose [(plugs)]

		if object? plugs [
			plugs: compose [(plugs)]
		]
		
		if as [
			spec: append copy spec compose/deep [valve: make valve [type: (to-lit-word valve-type)]]
		]
		plug: make type spec
		;plug/shared-states: type/shared-states
		
		plug/valve/init plug
		
		if any [piped pipe][
			plug/valve/new-pipe plug
		]
		
		if fill [
			plug/valve/fill plug data
		]
		if link [
			;print "#################################"
			link*/label plug plugs lbl
;			forall plugs [
;				either lbl [
;					plug/valve/link/label plug first plugs lbl
;				][
;					plug/valve/link plug first plugs
;				]
;			]
		]
		vout
		first reduce [plug plug: plugs: data: none] ; clean GC returnf
	]

	
	;--------------------------
	;-    build()
	;--------------------------
	; purpose:  replaces make for context which copies functions from one object to another.
	;           
	; inputs:   
	;
	; returns:  
	;
	; notes:    -care must be taken, because from there on, binding to self is impossible.
	;           -you MUST provide attributes and values in pair within the spec... its not
	;            arbitrary code.
	;
	; tests:    
	;--------------------------
;	build: funcl [
;		base-object [object!]
;		spec [block!]
;	][
;		vin "build()"
;		sw: none
;		
;		parse spec [
;			some [
;				set sw set-word!
;				[
;					set-word! (
;						to-error "liquid/build() cannot use chained set-words in spec (ex: [this: that: 66] is invalid)"
;					)
;					| skip
;				]
;			]
;		]
;		
;		vout
;	]
;	


	;-----------------
	;-    destroy()
	;-----------------
	destroy: func [
		plug [object!]
	][
		plug/valve/destroy plug
	]
	
	


	;-----------------------------------------
	;-    true?()
	;-----------------------------------------
	true?: func [value][value = true]


	;------------------------------
	;-    count()
	;---
	while*: get in system/words 'while
	count: func [;
		series [series!]
		value
		/while wend
		/until uend
		/within min "we must find at least one value before hitting this index, or else we return 0"
		/local counter i item
	][
		counter: 0
		i: 0
		while* [ 
			(not tail? series)
		][
			i: i + 1
			if find item: copy/part series 1 value [
				counter: counter + 1
			]
			; check if we hit the end condition once we started counting value
			if all [while counter > 0] [
				if not find item wend [
					series: tail series
				]
			]
			; check if we hit the end condition once we started counting value
			if all [until counter > 0] [
				if find item uend [
					series: tail series
				]
			]
			
			; are we past minimum search success range?
			if all [
				within
				counter = 0
				i >= min
			][
				series: tail series
			]
				
			
			series: next series
		]
		
		counter
	];

	
	;-----------------------------------------
	;-    fill()
	;-----------------------------------------
	fill: func [
		"shortcut for a plug's fill method"
		plug [object!]
		value
		/channel ch
	][
		either channel [
			plug/valve/fill/channel plug value ch
		][
			plug/valve/fill plug value
		]
	]
	
	
	;-----------------------------------------
	;-    pipe()
	;-----------------------------------------
	pipe: func [
		"converts a plug into a pipe, keeps any value it had by default."
		plug [object!]
		/only "Do not fill any value in the pipe, also prevents a cleanup on given plug."
		/with val
	][
		vin "pipe()"
		vprobe type? :val
		
		plug/valve/new-pipe plug
		unless only [
			unless with [
				val: plug/valve/content plug
			]
			fill plug val
		]
		val: none
		vout
		
		plug
	]
	
	
	
	;-----------------------------------------
	;-    content/cleanup()
	;-----------------------------------------
	content: funcl [
		"shortcut for a plug's content method"
		plug [object!]
		/channel ch [word!]
	][
		vin"content()"
		
		r: either channel [
			plug/valve/cleanup/channel plug ch
		][
			plug/valve/cleanup plug
		]
		vout
		
		r
	]
	
	cleanup: :content
	
	
	;-----------------
	;-    dirty()
	;-----------------
	dirty: func [
		plug [object!]
	][
		plug/valve/dirty plug
	]
	
	
	;-----------------
	;-    notify()
	;-----------------
	dirty: func [
		plug
	][
		plug/valve/notify plug
	]
	
	

	;-----------------------------------------
	;-    link()
	;-----------------------------------------
	link: func [
		"shortcut for a plug's link method"
		observer [object!]
		subordinate [object! block!]
		/label lbl [word! none!]
		/reset "will call reset on the link method (clears pipe or container constraints, if observer is piped)"
		/exclusive "Only allow one link per label or whole unlabled plug"
		/local blk val
	][
		;probe first subordinate
		;probe mold/all head subordinate
		
		either block? subordinate [
			;probe subordinate
			;vprobe reduce ["linking a block of plugs: " extract subordinate 2]
			;probe length? subordinate
			forall subordinate [
				val: pick subordinate 1
				
				either any [
					set-word? :val
					lit-word? :val
				][
					change subordinate to-word val
				][
					;print ["APPLYING :  type?: " type? val]
					 
					change subordinate do val
					;probe type? pick subordinate -1
				]
			]
			blk: subordinate: head subordinate
		][
			blk: subordinate: compose [(subordinate)]
		]
		foreach subordinate blk [
			; we can now specify the label directly within the block, so we can spec a whole labeled 
			; link setup in one call to link
			either word? subordinate [
				lbl: subordinate
			][
				
				any [
					all [lbl reset       observer/valve/link/label/reset observer subordinate lbl]
					all [lbl exclusive   observer/valve/link/label/exclusive observer subordinate lbl]
					all [lbl             observer/valve/link/label observer subordinate lbl]
					all [reset    (reset: none true)       observer/valve/link/reset observer subordinate ]
					all [exclusive       observer/valve/link/exclusive observer subordinate ]
					observer/valve/link observer subordinate
				]
			]
		]
	]
	
	
	;-----------------
	;-    unlink()
	;-----------------
	unlink: func [
		observer [object!]
		/detach
		/only subordinate [object!] "unlink only specified subordinate from observer, silently ingnores invalid subordinate"
	][
	
		if detach [
			observer/valve/detach observer
		]
	
		either only [
			observer/valve/unlink/only observer subordinate
		][
			observer/valve/unlink observer
		]
	]
	
	
	;--------------------------
	;-     insubordinate()
	;--------------------------
	; purpose:  high-level api for the valve's insubordinate method.
	;
	; inputs:   
	;
	; returns:  
	;
	; notes:    
	;
	; tests:    
	;--------------------------
	insubordinate: funcl [
		subordinate [object!]
	][
		vin "insubordinate()"
		subordinate/valve/insubordinate subordinate
		vout
	]
	
	
	
	
	
	;-----------------
	;-    attach()
	;-----------------
	attach: func [
		observer [object!]
		pipe [object!]
		/to channel
		/preserve "our value is kept when attaching, so that the pipe will immediately use our value(we fill pipe)"
		/local val
	][
		if preserve [
			val: content observer
		]
		either to [
			observer/valve/attach/to observer pipe channel
		][
			observer/valve/attach observer pipe
		]
		if preserve [
			fill observer val
		]
	]
	
	;-----------------
	;-    detach()
	;-----------------
	detach: func [
		plug
		/only
	][
		either only [
			plug/valve/detach/only plug
		][
			plug/valve/detach plug
		]
		
	]
	
	
	
	; just memorise so we can use this enhanced version within liquify
	link*: :link


	;--------------------
	;-    objectify()
	;--------------------
	objectify: func [
		"takes a process func data input and groups them into an object."
		;plug [object!]
		data [block!]
		/local blk here plugs
	][
		blk: compose/only [unlabeled: (plugs: copy [])]
		parse data [
			any [
				[here: word! (append blk to-set-word pick here 1 append/only blk plugs: copy [])]
				|
				[here: skip (append plugs pick here 1)]
			]
		]
		
		; parse plug/subordinates
		context blk
		
	]

	
	
	;--------------------
	;-    is?()
	;--------------------
	is?: func [
		"tries to find a word within the valve definition which matches qualifier: '*qualifier*"
		plug [object!]
		qualifier [word!]
	][
		;print "IS?"
		found? in plug/valve to-word rejoin ["*" qualifier "*"]
	]
	
	
	
	;-----------------
	;-    dirty?()
	;-----------------
	dirty?: func [
		plug [object!]
	][
		true = plug/dirty?
	]
	
	
			
	;-----------------
	;-    plug?()
	;-----------------
	plug?: func [
		plug "returns plug if object is based on a liquid plug, none otherwise"
	][
		all [
			object? plug
			in plug 'liquid
			in plug 'valve
			in plug 'dirty?
			object? plug/valve
			in plug/valve 'setup
			in plug/valve 'link
			in plug/valve 'cleanup
			plug
		]
	]
	
	;-----------------
	;-    piped?()
	;-----------------
	piped?: func [
		plug "returns plug if object has a pipe server."
	][
		all [
			plug? plug
			plug? plug/pipe?
		]
	]
	
	
	;- LIQUID DIALECTS


	
	;--------------------------
	;-     catalogue()
	;--------------------------
	; purpose:  collects a node within a catalogue object, uses the plug/valve/type value to set it up.
	;
	; inputs:  a catalogue and a plug (class or instance).
	;
	; returns:  the new catalogue
	;
	; notes:    
	;
	; tests:    [   catalogue !plug   ]
	;--------------------------
	catalogue: *catalogue: funct [
		plug [object! block!]
		cat [object! none!] "if none, creates a new one from scratch"
	][
		vin "liquid/catalogue()"
		
		if none? cat [
			cat: context []
		]
		
		plugs: compose [(plug)]
		
		foreach plug plugs [
			cat: make cat reduce [ to-set-word plug/valve/type plug ]
		]
		
		vout
		cat
	]
	



	;- PLUG CLASS MACROS
	;
	; the following are considered macros, which allow simple wrapping around common plug class creation.
	; the returned plugs are NOT liquified.
	


	
	;--------------------------
	;-    container()
	;--------------------------
	; purpose: just a quick way to create a filled container plug
	;
	; inputs:  the data to put within the container
	;
	; returns: the !plug 
	;
	; notes:   uses !default-plug
	;--------------------------
	container: func [
		data "Any data you want to put in the filled plug."
	][
		vin "liquid/container()"
		
		plug: liquify/fill !default-plug :data
		
		vout
		plug
	]
	
	
	
	
	;--------------------------
	;-    formulate()
	;--------------------------
	; purpose:  creates a valve using another as the reference.
	;
	;           the created valve will SHARE the functions from the source valve which haven't changed.
	;
	; inputs:   a plug to derive from
	;           a spec to formulate to
	;
	; returns:  
	;
	; notes:    -If the spec is a block and you put a block as the first item of the given spec, it will be added to the 
	;            item of the plug directly. This allows you to add variables within the instance data.  obviously this 
	;            block is removed from the spec when generating the valve.
	;
	;           -If the spec is an object, we will try to detect if the object is a valve or a plug.
	;            The plug or valve are expected to be partial... whatever is specified will overwrite the given values
	;            in the source. when the object cannot be recognized as a plug or valve, we assume it's a valve extension.
	;
	; tests:    
	;--------------------------
	formulate: funcl [
		source [object!] "A plug or valve to use as the source class."
		spec [block! object!] "Block! or object! to replace values in the source. if the source is a valve, we return a modified !plug."
	][
		vin "liquid/formulate()"
		;vprobe type? source
		;vprobe type? spec
		
		
		source-is-plug?: false
		
		;-----------
		; get source valve
		;-----------
		plug-spec: any [
			all [
				object? spec
				any [
					; plug was given, spec is the plug
					all [
						object? get in spec 'valve
						in spec 'liquid
						spec
					]
					
					; a valve was given, spec is empty.
					[]
				]
				
			]
			
			; does the given block have a spec at its start.
			all [
				block? plug-spec: first spec
				remove spec
				plug-spec
			]
			
			; no way to find a plug spec ... its a direct valve spec
			[]
		]
			
		
		
		
		
		;-----------
		; get source valve
		;-----------
		valve: all [
			valve: any [
				all [
					object? get in source 'valve
					in source 'liquid
					source/valve
				]
				all [
					source-is-plug?: true
					source
				]
			]
			in valve 'instigate
			in valve 'propagate
			valve
		]
		
		unless valve [
			to-error "formulate(): cannot find valve in given source"
		]
		
		
		;-----------
		; get list of words to redefine in source
		;-----------
		new-words: any [
			all [
				block? spec
				extract-set-words spec
			]
			all [
				object? spec
				words-of object
			]
			to-error "formulate(): spec contains no words to redefine in source"
		]
		
		
		;--------------------------------------------
		; build new valve spec
		;-----------
		;  we set all the non-specified words of the valve to none, in order
		;  to prevent the derived valve from accessing any of the valve directly.
		;
		;  valve methods MUST ALWAYS use plug/valve/method.  
		;  They must never use direct binding.
		;-----------
		vlv-words: words-of valve
		forall vlv-words [
			change vlv-words to-set-word first vlv-words
		]
		append vlv-words #[none]
		
		vlv-spec: append vlv-words spec
		
		;probe spec 
		;ask ".."
		
		
		;--------------------------------------------
		; build the new valve
		;--------------------------------------------
		new-valve: make valve spec
		foreach word words-of valve [
			unless find new-words word [
				set/any in new-valve word get/any in valve word
			]
		]
		
		
		;--------------------------------------------
		; generate the plug spec
		;--------------------------------------------
		
		basis: either source-is-plug? [ source ][ !plug ]
		
		
		new-plug: make basis append compose [  valve: (new-valve)  ] plug-spec
		new-plug/valve: new-valve
		
		
		
;		ask ""
;		
;		valve: plug/valve
;		vlv-words: words-of valve
;		new-plug: make plug spec
;		
;		unless same? new-plug/valve plug/valve [
;			foreach word blk [
;				vprobe word
;				unless find words word [
;					set in new-plug word get in plug word
;				]
;			]
;		]
		vout
		
		new-plug
	]
	
	
	


	;-----------------
	;-    --process()
	;
	; creates a simple plug which expets to be linked, building the process() function
	; automatically and returning the new plug class.
	;
	; <DEPRECATED>: use processor instead.
	;-----------------
	--process: func [
		type-name [word!]
		locals [block!] "plug and data will be added to your process func"
		body [block!]
		/with user-spec [block!] "give a spec block manually"
		/like refplug [object!] 
		/local plug spec
	][
		vin [{process()}]
		
;		?? locals
;		if find locals 'plug [
;				?? type-name
;				?? body
;		
;				?? user-spec
;				?? like
;				ask "!"
;		]
		
		spec: [
			valve: make valve [
				type: type-name
				process: make function! head insert copy locals [plug data /local] body
			]
		]
		
		if user-spec [
			insert spec user-spec
		]
		
		plug: make any [refplug !default-plug] spec
		vout
		plug
	]
	
	
	
	;--------------------------
	;-    processor()
	;--------------------------
	; purpose: shortcut to plug class creation which expects to be linked by default, 
	;          builds the process() function automatically.
	;
	; inputs:   type-name:  class name stored in plug/valve/type
	;           body:       the process function's body
	;
	; returns:  a new plug class.
	;
	; notes:    an updated version of process(), uses 'FUNCL and formulate
	;
	; tests:    
	;--------------------------
	processor: funcl [
		type-name [word!] "set the plug's class name."
		body [ block! any-function! ] "plug/valve/process() function body."
		/with plug-spec [block!] "Extend the plug spec manually"
		/valve vlv-spec [block!] "Extend the valve spec manually"
		/base refplug [object!]  "Manually provide the base class to derive"
		/safe "If body is given as a function!, wrap the processor in an attempt"
	][
		vin "processor()"
		
		if any-function? :body [
			;----
			; creating  a context allows us to bind everything much more easily.
			; it also hides the function being used so that your nodes don't show
			; the private code you may be using.
			;----
			ctx: context [
				plug-func: :body
				blk: compose [ 
					plug/liquid: apply :plug-func data 
				]
				
				if safe [
					blk: reduce ['attempt blk]
				]
				
				fbody: compose [
					vin [ "" plug/valve/type "[" plug/sid "]/process()" ]
					 (blk)
					vout
				]
				vprint "===================>>>"
				vprint mold/all fbody
				vprint "===================>>>"
				fbody: copy/deep fbody
			]
			body: ctx/fbody
		]
		
				
		;---
		; first item in spec is a block.
		; formulate() uses this as a plug spec
		;
		; if /valve is not given, appending a trailing none is harmless.
		spec: append compose/only [
			(plug-spec)
			type: (to-lit-word type-name)
			process: funcl [ plug  data ] (body)
		] vlv-spec
		
		
		v?? spec
		
		;---
		; !default-plug is !plug, by default, unless changed manually by app.
		plug: formulate any [ refplug !default-plug ] spec
		
		vout
		plug
	]
	
	
	
	
	
	
	
	;-----------------
	;-    bridge()
	;
	; creates two plugs.
	;
	; a bridge server, for which you provide the valve spec, and the bridge client, which is returned
	; with its pipe-server-class setup by default.
	;
	; the client spec is used directly in the make call, so you can tweak the client before it gets
	; assigned a bridge server.
	;-----------------
	bridge: func [
		bridge-name [word!] ; '-client and '-server  are added to respective plug types.
		client-spec [block! none!]
		server-spec [block!]
		/local bridge client server-type client-type
	][
		server-type: to-word join to-string bridge-name "-server"
		client-type: to-word join to-string bridge-name "-client"
		
		bridge: make !default-plug server-spec
		
		bridge/pipe?: 'bridge
		
		bridge/valve/type: server-type
		
		client: make !default-plug any [client-spec []]
		client: make client [
			valve: make valve [
				pipe-server-class: bridge
				type: client-type
			]
		]
		client
	]
		


	;-  
	;-----------------------
	;- !PLUG
	;-----------------------
	!plug: !default-plug: make object! [
		;------------------------------------------------------
		;-    VALUES
		;------------------------------------------------------
		
		;-----------------------------------------
		;-       sid:
		;-----------------------------------------
		; a unique serial number which will never change
		;-----------------------------------------
		sid: 0	; (integer!)
		
		
		
		;-----------------------------------------
		;-       observers:
		;-----------------------------------------
		; who is using ME (none or a block)
		;-----------------------------------------
		observers: none
		
		
		;-----------------------------------------
		;-       subordinates:
		;-----------------------------------------
		; who am I using  (none or a block)
		;-----------------------------------------
		subordinates: none
		
		
		;-----------------------------------------
		;-       dirty?:
		;-----------------------------------------
		; has any item above me in the chain changed?
		; some systems will always set this back to false,
		; when they process at each change instead of deffering eval.
		;
		; v0.8.0 added the 'clogged state.  this is 
		;        defined as a dirty state within the
		;        node, but prevents any propagation
		;        from crossing the !plug, allowing
		;        for single refresh which doesn't
		;        cause the whole tree to become dirty.
		;
		;        usefull in controled environments
		;        especially to contain stainless?
		;        plugs to over reach observers which
		;        actually do not need to now about
		;        our own local refreshes.
		;
		; when plugs are new, they are obviously dirty.
		dirty?: True
		
		
		;-----------------------------------------
		;-       frozen?:
		;-----------------------------------------
		; this allows you to prevent a !plug from
		; cleaning itself.  the plug remains dirty
		; will never be processed.
		;
		; this is a very powerfull optimisation in many
		; circumstances.  We often know within a manager,
		; that a specific network has to be built before
		; it has any meaning (several links are needed,
		; data has to be piped, but isn't available yet, etc)
		; normaly, if any observer is stainless? or being
		; viewed dynamically, it will cause a chain reaction
		; which is ultimately useless and potentially slow.
		;
		; imagine a graphic operation which takes a second
		; to complete for each image linked... if you link
		; 5 images, you end up with a fibonacci curve of wasted time
		; thus 1 + 2 + 3 + 4 + 5 ... 13 operations, when only the last
		;  5 are really usefull!
		; as the data set grows, this is exponentially slow.
		;
		; if we freeze the node while the linking occurs,
		; and then unfreeze it, only one process is called,
		; with the 5 links.
		;
		; you could also use a function and let it react based
		; on conditions.
		;
		; nodes aren't frozen by default cause it would be tedious
		; to manage all the time, but use this when its 
		; worth it!
		frozen?: False
		
		
		;-----------------------------------------
		;-       stainless?:
		;-----------------------------------------
		; This forces the container to automatically regenerate content when set to dirty!
		; thus it can never be dirty...
		;
		; used sparingly this is very powerfull, cause it allows the end of a procedural
		; tree to be made "live".  its automatically refreshed, without your intervention :-)
		;-----------------------------------------
		stainless?: False
		
		
		;-----------------------------------------
		;-       pipe?:
		;-----------------------------------------
		;
		; pipe? is used to either determine if this liquid IS a pipe or if it is connected to one.
		;
		; v0.5.1 change: now support 'simple  as an alternative plug mode, which allows us to fill data
		; in a plug without actually generating/handling a pipe connection.  The value is simply dumped
		; in plug/liquid and purify may adapt it as usual
		;
		; This new behaviour is called containing, and like piping, allows liquids to store data
		; values instead of only depending on external inputs.
		;
		; This property will also change how various functions react, so be sure not to play around
		; with this, unless you are sure of what you are doing.
		;
		; by setting pipe? to True, you will tell liquid that this IS a pipe plug.  This means that the plug
		; is responsible for notifying all the subordinates that its value has changed.
		; it uses standard liquid procedures to alert piped plugs that its dirty, and whatnot.
		;
		; By setting this to a plug object, you are telling liquid that you are CONNECTED to a 
		; pipe, thus, our fill method will send the data to IT.
		;
		; note that you can call fill directly on a pipe, in which case it will fill its pipe clients
		; normally.
		;
		; also, because the pipe IS a plug, you can theoretically link it to another plug, but this 
		; creates issues which are not designed yet, so this useage is not encouraged, further 
		; versions might specifically handle this situation by design.
		;
		; v1.0.2 'simple pipes are relabeled 'container pipes
		;
		;-----------------------------------------
		pipe?: none
		
		;-----------------------------------------
		;-       mud:
		;-----------------------------------------
		; in containers/pipes: stores manually filled values
		;
		; in linked nodes: can be used as a cache for returning always the same series out of process...
		; basically, it would be equal to liquid, when there is no error, some other values otherwise.
		mud: none
		
		;-----------------------------------------
		;-       liquid:
		;-----------------------------------------
		; stores processing results (cached process) allows lazyness, since results are kept.
		; this is set by the content method using the return value of process
		liquid: none
		
		
		;-----------------------------------------
		;-       shared-states:
		;
		; deprecated (unused and slows down operation)
		;-----------------------------------------
		; this is a very special block, which must NOT be replaced arbitrarily.
		; basically, it allows ALL nodes in a liquid session to extremely 
		; efficiently share states.
		;
		; typical use is to prevent processing in specific network states
		; where we know processing is useless, like on network init.
		;
		; add  'init to the shared-states block to prevent propagation whenever you are
		; creating massive amounts of nodes. then remove the init and call cleanup on any leaf nodes
		;
		; the instigate func and clear func still work.  they are just
		; not called in some circumstances.
		;
		; making new !plugs with alternate shared-states blocks, means you can separate your
		; networks, even if they share the same base clases.
		;-----------------------------------------
		;shared-states: []
		
		
		
		;-       channel:
		; if plug is a channeled pipe, what channel do we request from our (bridged) pipe server?
		channel: none
		
		
		
		
		;-----------------------------------------
		;-       linked-container?:
		; DEPRECATED.
		;-----------------------------------------
		; if set to true, this tells the processing mechanisms that you wish to have both 
		; the linked data AND mud, which will be filtered, processed and whatever 
		; the mud will always be the last item on the list.
		;
		;
		; commented in v1.0.5 ... might crash some older apps!!!!
		; 
		; linked-container: linked-container?: false
		
		
		;-----------------------------------------
		;-       resolve-links?:
		;-----------------------------------------
		; tells pipe clients that they should act as a normal
		; dependency plug even if receiving pipe events.
		;
		; note that this ALSO provides the same featues that linked-containers?
		; used to provide, with the difference that we can now control how the 
		; links and/or mud are managed
		;
		; as of v1.2.1, the VALUE of resolve-links is now more than just true/false.
		;
		;  choose from these values:
		;     - 'LINK-AFTER
		;     - 'LINK-BEFORE
		;     - 'LINKED-MUD : if linked, (a single link used) it instigates and sets mud to the first value in instigation block. link must not be labeled.
		;     - #[true] (equivalent to 'LINK-AFTER, for compatibility)
		;     - #[false] #[none],   don't resolve links
		;-----------------------------------------
		resolve-links?: none
		
		
		
		
		
		
		
		
		;------------------------------------------------------
		;-    VALVE (class)
		;------------------------------------------------------
		valve: make object! [
			;-        qualifiers:
			;-            *plug*
			; normally, we'd add a word in the definition like so... but its obviously useless adding
			; a word within all plugs
			; the value of the qualifier is a version, which identifies which version of a specific
			; master class we are derived from
			; ex:
			;
			; *plug*: 1.0  
			
			
			;--------------
			; class name (should be word)
			;-        type:
			type: '!plug
			
			;--------------
			; used to classify types of liquid nodes.
			;-        category:
			category: '!plug
			
			
			;-----------------
			;-        pipe-server-class:
			; this is set to !plug just after the class is created.
			; put the class you want to use automatically within you plug derivatives
			pipe-server-class: none
			
			
			
			
			
			
			;-----------------------------------------------------------------------------------------------------------
			;
			;-     - MISCELANEOUS METHODS
			;
			;-----------------------------------------------------------------------------------------------------------
			

			;---------------------
			;-        cycle?()
			;---------------------
			; check if a plug is part of any of its subordinates
			;---------------------
			cycle?: func [
				"checks if a plug is part of its potential subordinates, and returns true if a link cycle was detected. ^/^-^-If you wish to detect a cycle BEFORE a connection is made, supply observer as ref plug and subordinate as plug."
				plug "the plug to start looking for in tree of subordinates" [object!]
				/with "supply reference plug directly"
					refplug "the plug which will be passed along to all the subordinates, to compare.  If not set, will be set to plug" [block!]
				/debug "(disabled in this optimized release)  >>> step by step traversal of tree for debug purposes, should only be used when prototyping code"
				/local cycle? index len
			][
				cycle?: false

				; is this a cycle?
				either all [
					(same? plug refplug)
					0 <> plug/valve/links plug ; fix a strange bug in algorythm... cycle? must be completely revised
				][
					vprint/always "WARNING: liquid data flow engine Detected a connection cycle!"
					
					;print a bit of debugging info...
					vprint/always plug/valve/type
					vprint/always plug/valve/links plug
					
					cycle?: true
				][

					if none? refplug [
						refplug: plug
					]

					;does this plug have subordinates
					if plug/valve/linked? plug [
						index: 1
						len: length? plug/subordinates

						until [
							; <FIXME> quickfix... do MUCH more testing
							if object? plug/subordinates/:index [	
								cycle?: plug/subordinates/:index/valve/cycle?/with plug/subordinates/:index refplug
							]
							index: index + 1
							any [
								cycle?
								index > len
							]
						]
					]
				]

				refplug: plug: none


				cycle?
			]


			;---------------------
			;-        cycle?()
			;---------------------
			; check if a plug is part of any of its subordinates
			;---------------------
			cycle?: func [
				"checks if a plug is part of its potential subordinates, and returns true if a link cycle was detected. ^/^-^-If you wish to detect a cycle BEFORE a connection is made, supply observer as ref plug and subordinate as plug."
				plug "the plug to start looking for in tree of subordinates" [object!]
				/with "supply reference plug directly"
					refplug "the plug which will be passed along to all the subordinates, to compare.  If not set, will be set to plug" [block!]
				/debug "step by step traversal of tree for debug purposes, should only be used when prototyping error generating code"
				/local cycle? index len
			][
				if all [
					value? 'do-liquid-cycle-debug
					do-liquid-cycle-debug
				][
					debug: true
				]
				either debug [
					vin/always ["liquid/"  plug/valve/type  "[" plug/sid "]/cycle?" ]
				][
					vin ["liquid/"  plug/valve/type  "[" plug/sid "]/cycle?" ]
				]
				cycle?: false
				if debug [
					if refplug [
						vprint/always ["refplug/sid: " refplug/sid ]
					]
				]

				; is this a cycle?
				either (same? plug refplug) [
					vprint/always "WARNING: liquid data flow engine Detected a connection cycle!"
					cycle?: true
				][

					if none? refplug [
						refplug: plug
					]

					;does this plug have subordinates
					if plug/valve/linked? plug [
						if debug [
							vprint/always "-> press enter to move on cycle check to next subordinate"
							ask ""
						]
						index: 1
						len: length? plug/subordinates

						until [
							; <FIXME> quickfix... do MUCH more testing
							if object? plug/subordinates/:index [	
								cycle?: plug/subordinates/:index/valve/cycle?/with plug/subordinates/:index refplug
							]
							index: index + 1
							any [
								cycle?
								index > len
							]
						]
					]
				]

				refplug: plug: none

				either debug [
					vout/always
				][
					vout
				]

				cycle?
			]
			
			

			;---------------------
			;-        stats()
			;---------------------
			stats: func [
				"standardized function which print data about a plug"
				plug "plug to display stats about" [object!]
				/local lbls item vbz labels pipe
			][
				vin/always  ["liquid/"  type  "[" plug/sid "]/stats" ]
				vprint/always "================"
				vprint/always "PLUG STATISTICS:"
				vprint/always "================"
				
				
				vprint/always "LABELING:"
				vprint/always "---"
				vprint/always [ "type:      " plug/valve/type ]
				vprint/always [ "category:      " plug/valve/category ]
				vprint/always [ "serial id: " plug/sid]
				
				
				vprint/always ""
				vprint/always "LINKEAGE:"
				vprint/always "---"
				vprint/always ["total subordinates: " count plug/subordinates object! ]
				vprint/always ["total observers: " length? plug/observers  ]
				vprint/always ["total commits: " count plug/subordinates block! ]
				if find plug/subordinates word! [
					vbz: verbose
					verbose: false
					lbls: plug/valve/links/labels plug
					labels: copy []
					foreach item lbls [
						append labels item
						append labels rejoin ["("  plug/valve/links/labeled plug item ")"]
					]
					verbose: vbz
					vprint/always ["labeled links:  (" labels ")"]
				]
				
				pipe: plug/valve/pipe plug
				probe type? pipe/pipe?
				probe pipe/pipe?
				pipe: plug/valve/pipe plug
				if 'bridge = pipe/pipe? [
					vprint/always ""
					vprint/always ["BRIDGE CHANNELS:"]
					vprint/always "---"
					vprobe/always extract pipe/observers 2
				]
				
				vprint/always ""
				vprint/always ["VALUE:"]
				vprint/always "---"
				either series? plug/liquid [
					;print "$$$$$$$$"
					vprint/always rejoin ["" type?/word plug/liquid ": " copy/part mold/all plug/liquid 100 " :"]
				][
					;print "%%%%%%%%"
					vprint/always rejoin ["" type?/word plug/liquid ": " plug/liquid]
				]
				
				
				vprint/always ""
				vprint/always "INTERNALS:"
				vprint/always "---"
				vprint/always [ "pipe?: " any [all [object? plug/pipe? rejoin ["object! sid(" plug/pipe?/sid ")"]]	plug/pipe? ]]
				vprint/always [ "stainless?: " plug/stainless? ]
				vprint/always [ "dirty?: " plug/dirty? ]
				;vprint/always [ "shared-states: " plug/shared-states ]
				vprint/always [ "resolve-links?: " mold/all plug/resolve-links? ]
				either series? plug/mud [
					vprint/always [ "mud: "  copy/part mold/all plug/mud 100 ]
				][
					vprint/always [ "mud: " plug/mud ] 
				]
				
				vprint/always "================"
				vout/always
			]


			;-----------------------------------------------------------------------------------------------------------
			;
			;-    - CONSTRUCTION METHODS
			;
			;-----------------------------------------------------------------------------------------------------------
			

			;---------------------
			;-        init()
			;---------------------
			; called on every new !plug, of any type.
			;
			;  See also:  SETUP, CLEANSE, DESTROY
			;---------------------
			init: func [
				plug "plug to initialize" [object!]
			][
				plug/sid: alloc-sid
				vin  ["liquid/"  type  "[" plug/sid "]/init" ]
			
				plug/observers: copy []
				plug/subordinates: copy []
				
				; this is a bridged pipe server
				if plug/pipe? = 'bridge [
					; this is persistent
					; each channel will be referenced with a select inside the liquid.
					;
					; example for a color bridge
					; [ R [25] G [50] B [0] A [200] RGB [25.50.0.200] ]
					; 
					plug/liquid: copy []
				]

				append plug-list plug/sid
				append plug-list plug

				setup plug
				cleanse plug

				; allow per instance init, if that plug type needs it.  Use as SPARINGLY as possible.
				if in plug 'init [
					plug/init
				]
				vout
			]
			

			;---------------------
			;-        setup()
			;---------------------
			;  IT IS ILLEGAL TO CALL SETUP DIRECTLY IN YOUR CODE.
			;
			; called on every NEW plug of THIS class when plug is created.
			; for any recyclable attributes, implement them in cleanse.
			; This function is called by valve/init directly.
			;
			; At this point (just before calling setup), the object is valid 
			; wrt liquid, so we can already call valve methods on the plug 
			; (link, for example)
			;
			;  See also:  INIT, CLEANSE, DESTROY
			;---------------------
			setup: func [
				plug [object!]
			][
			]


			;---------------------
			;-        cleanse()
			;---------------------
			; use this to reset the plug to a neutral and default value. could also be called reset.
			; this should be filled appropriately for plugs which contain other plugs, in such a case,
			; you should cleanse each of those members if appropriate.
			;
			; This is the complement to the setup function, except that it can be called manually
			; by the user within his code, whenever he wishes to reset the plug.
			;
			; init calls cleanse just after setup, so you can put setup code here too or instead. 
			; remember that cleanse can be called at any moment whereas setup will only 
			; ever be called ONCE.
			;
			; optionally, you might want to unlink the plug or its members.
			;
			;  See also:  SETUP, INIT, DESTROY
			;---------------------
			cleanse: func [
				plug [object!]
			][

				;plug/mud: none
				;plug/liquid: none ; this just breaks to many setups.  implement manually when needed.

				; cleanup pointers
				plug: none
			]



			;------------------------
			;-        destroy()
			;------------------------
			; use this whenever you must destroy a plug.
			; destroy is mainly used to ensure that any internal liquid is unreferenced in order for the garbage collector
			; to be able to properly recuperate any latent liquid.
			;
			; after using destroy, the plug is UNUSABLE. it is completely broken and nothing is expected to be usable within.
			; nothing short of calling init back on the plug is expected to work (usually completely rebuilding it from scratch) .
			;
			;  See also:  INIT SETUP CLEANSE
			;------------------------
			destroy: func [
				plug [object!]
			][
				plug/valve/unlink plug
				plug/valve/insubordinate plug
				plug/valve/detach plug
				plug/mud: none
				if plug/pipe? = 'bridge [
					clear head plug/liquid
				]
				plug/liquid: none
				plug/subordinates: none
				plug/observers: none
				plug/pipe?: none
				;plug/shared-states: none
				plug: first reduce [plug/sid plug/sid: none]
				if plug: find plug-list plug [
					remove/part plug 2
				]
				;voff
			]


			;-----------------------------------------------------------------------------------------------------------
			;
			;-     - PLUG LINKING METHODS
			;
			;-----------------------------------------------------------------------------------------------------------
			
			;---------------------
			;-        link?()
			;---------------------
			; validate if plug about to be linked is valid.
			; default method simply refuses if its already in our subordinates block.
			;
			; Be carefull, INFINITE CYCLES ARE ALLOWED IF YOU REPLACE THIS FUNC
			;---------------------
			link?: func [
				observer [object!] "plug about to perform link"
				subordinate [object!] "plug which wants to be linked to"
			][
				
				either check-cycle-on-link? [
					
					; by default, plugs now do a verification of processing cycles
					; if you need speed and can implement the cycle call within the manager instead,
					; you can simply replace this func, but the above warning come into effect.
					; 
					; the cycle check slows down linkage but garantees prevention of deadlocks.
					not if cycle?/with subordinate observer [
						if liquid-error-on-cycle? [
							to-error "LIQUID CYCLE DETECTED ON LINK"
						]
						true
					]
				][true]
			]



			;---------------------
			;-        link()
			;---------------------
			; link to a plug (of any type)
			;
			; v0.5
			; if subordinate is a pipe, we only do one side of the link.  This is because 
			; the oberver connects to its pipe (subordinate) via the pipe? attribute.
			;
			; v0.5.4
			; we now explicitely allow labeled links and even allow them to be orphaned.
			; so we support  0-n number of links per label;
			;
			; v1.0.2 
			; complete rewrite, at least twice as fast.
			; does not manage pipes anymore.
			;
			; this actually means we can now LINK pipe servers and use them in resolve-links? mode.
			; this is very usefull with bridged pipes since it allows link TO data which are used 
			; as parameters for the bridging process().
			; 
			;---------------------
			link: func [
				observer [object!] "plug which depends on another plug, expecting liquid"
				subordinate [object! none! block!] "plug which is providing the liquid. none is only supported if label is specified. block! links to all plugs in block"
				/head "this puts the subordinate before all links... <FIXME> only supported in unlabeled mode for now"
				/label lbl [word! string!] "the label you wish to use if needing to reference plugs by name. "
				/exclusive  "Is the connection exclusive (will disconnect already linked plugs), cooperates with /label refinement, note that specifying a block and /explicit will result in the last item of the block being linked ONLY."
				;/limit max [integer!] limit-mode [word!] "<TO DO> NOT IMPLEMENTED YET !!! maximum number of connections to perform and how to react when limit is breached"
				/reset "Unpipes, unlinks the node first and IMPLIES EXCLUSIVE (label is supported as normal). This basically makes SURE the supplied subordinate will become the soul data provider and really will be used."
				/pipe-server "applies the link to our pipe-server instead of ourself.  we MUST be piped in some way."
				/local subordinates  plug ok?
			][
				vin ["liquid/" observer/valve/type "[" observer/sid "]/link()"]
				ok?: true ; unless link? returns true, all is good.
				
				
				if pipe-server [
					unless observer: observer/valve/pipe observer [
						to-error "liquid/link(): /pipe-server requires some form of piping (container, pipes, bridge)."
					]
				]
				
				if reset [
					observer/valve/detach observer
					observer/valve/unlink observer
					either label [
						observer/valve/link/label observer subordinate lbl 
					][
						observer/valve/link observer subordinate
					]
					vout
					return
				]
				
				; when exclusive, we unlink all appropriate subordinates from observer
				if exclusive [
					either object? subordinate [
						either label [observer/valve/unlink/only observer lbl][observer/valve/unlink observer]
					][
						to-error "liquid/link(): exclusive linking expects a subordinate of type object!"
					]
				]
				
				; make sure we don't try to link an unlabeled subordinate to none!
				; its valid for labels to be none since it simply adds the label to the subordinates block if its not there yet.
				; we call these orphaned labels
				if all [none? subordinate not label ][
					to-error "liquid/link(): only /label linking supports none! type subordinate!"
				]
				
				subordinates: any [
					all [
						label
						
						; re-use label or create it.
						any [
							all [
								; find this label
								subordinates: find/tail observer/subordinates lbl
								any [
									; we should link at head, so don't search for end of label's links.
									all [head subordinates]
									
									; move at next word (thus the end of this label's subordinates)
									find subordinates word!
									
									; we didn't find a word, so we are the last one
									tail subordinates
								]
							]
							; create new label, return after insert (thus tail)
							; head = tail since its a new label, so we don't have to check for this condition.
							insert tail observer/subordinates lbl
						]
					]
					; not labeled, just get the tail of subordinates block
					tail observer/subordinates
				]
				
				
				; now that we are at our index (labeled or not), just link any subordinates we where given (ignoring nones)
				foreach subordinate compose [(subordinate)] [
					either link? observer subordinate [
						total-links: total-links + 1 ; a general stats value
						if subordinate [
							subordinates: insert subordinates subordinate
						]
					][
						ok?: false
						break
					]
					
					; subordinate has to know that we are observing it for propagation purposes.
					insert tail subordinate/observers observer
					
					; callback which allows plugs to perform tricks after being linked
					observer/valve/on-link observer subordinate
				]
				
				; whatever happens, make sure observer isn't clean.
				observer/valve/dirty observer
				
				vout
				ok?
			]

			;-----------------
			;-        on-link()
			;-----------------
			; makes reacting to linking easier within sub-classes of !plug
			; 
			; this is called AFTER the link, so you can react to the link's position 
			; in the subordinates...  :-)
			;-----------------
			on-link: func [
				plug [object!]
				subordinate [object!]
			][
			]
			
			

			;---------------------
			;-        linked? ()
			;---------------------
			; is a plug observing another plug? (is it dependent or piped?)
			;---------------------
			linked?: func [
				plug "plug to verify" [object!]
				/only "does not consider a piped plug as linked, usually used when we want to go to/from (toggle) piped mode."
				/with subordinate [object!] "only returns true if we are linked with a specific subordinate"
				/local val
			][
				; not not converts arbitray values into booleans (only none and false return false)
				val: not not any [
					all [
						plug/subordinates
						not empty? plug/subordinates
						any [
							; any connection is good?
							not with
							; is the subordinate already linked?
							find plug/subordinates subordinate
						]	
					]
					all [not only object? plug/pipe?]
				]
				val
			]


			;---------------------
			;-        sub()
			;---------------------
			; returns specific links from our subordinates
			;---------------------
			sub: func [
				plug [object! block!]
				/labeled labl [word!] ; deprecated, backwards compatibility only.  do not use.  will eventually be removed
				/label lbl [word!]
				;/start sindex
				;/end eindex
				;/part amount
				/local amount blk src-blk
			][
				if labeled [lbl: labl label: true] ; deprecated, backwards compatibility only.  do not use.  will eventually be removed
				
				src-blk: any [
					all [block? plug plug]
					plug/subordinates
				]	
				
				either label [
					either label: find/tail src-blk lbl [
						unless amount: find label word! [ ; till next label or none (till end).
							amount: tail label
						]
						blk: copy/part label amount ; if they are the same, nothing is copied
					][
						blk: none
					]
				][
					blk: none
				]
				first reduce [blk src-blk: labeled: label: lbl: labl: amount: blk: none]
			]


			;---------------------
			;-        links()
			;---------------------
			; a generalized link querying method.  supports different modes based on refinements.
			;
			; returns the number of plugs we are observing
			;---------------------
			links: func [
				plug [object!] "the plug you wish to scan"
				/labeled lbl [word!] "return only the number of links for specified label"
				/labels "returns linked plug labels instead of link count"
				/local at lbls
			][
				either labels [
					either find plug/subordinates word! [
						foreach item plug/subordinates [
							if word! = (type? item) [
								lbls: any [lbls copy []]
								append lbls item
							]
						]
						lbls
					][none]
				][
					either labeled [
						either (at: find plug/subordinates lbl) [
							; count all objects until we hit something else than an object if and only if we find an object just past the label
							count/while/within at object! object! 2
						][
							; none is returned if the label is not in list
							none
						]	
					][
						count plug/subordinates object!
					]
				]
			]





			;---------------------
			;-        unlink()
			;---------------------
			; unlink myself
			; by default,  we will be unlinked from ALL our subordinates.
			;
			; note that as of v5.4 we support orphaned labels. This means we can have labels
			; with a count of 0 as their number of plugs.  This is in order to keep evaluation
			; and plug ordering intact even when replacing plugs.  many tools will need this, 
			; since order of connections can influence processing order in some setups.
			;
			; v.0.5.5 now returns the plugs it unlinked, makes it easy to unlink data, filter plugs
			;         and reconnect those you really wanted to keep.
			;---------------------
			unlink: func [
				plug [object!]
				/only oplug [object! integer! word!] "unlink a specifc plug... not all of them.  Specifying a word! will switch to label mode!"
				/tail "unlink from the end, supports /part (integer!) disables /only"
				/part amount [integer!] "Unlink these many plugs, default is all.  /part also requires /only or /tail ,  these act as a start point (if object! or integer!) or bounds (when word! label is given)."
				/label "actually delete the label itself if /only 'label is selected and we end up removing all plugs."
				/detach "call detach too, usefull to go back to link mode"
				/local blk subordinate count rval
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/unlink()"]
			
				
				if detach [
					plug/valve/detach plug
				]
				
				if linked? plug [
					rval: copy []
					if not part [
						amount: 1
					]
					if tail [
						; this activates tail-based unlinking with optional /part attribute
						only: true 
						oplug: (length? plug/subordinates) - amount + 1
					]
					either only [
						switch type?/word oplug [
							object! [
								if found? blk: find plug/subordinates oplug [
									rval: disregard/part plug blk amount
								]
							]

							integer! [
								; oplug is an integer
								; we should not be using labels in this case.
								
								rval: disregard/part plug (at plug/subordinates oplug) amount
							]
							
							none! [
								; only possible if /tail was specified
								vprint "REMOVING FROM TAIL!"
								
							]

							word! [
								if subordinate: find plug/subordinates oplug [
									lblcount: links/labeled plug oplug
									either part [
										; cannot remove more plugs than there are, can we :-)
										amount: min amount lblcount
									][
										; remove all links 
										amount: lblcount
									]
									
									; in any case, we can only remove the label if all links would be removed
									either all [
										label
										amount >= lblcount
									][
										; we must remove label and all its links
										remove subordinate
										rval: disregard/part plug subordinate amount
									][
										; remove all links but keep the label.
										; amount could be zero, in which case nothing happens.
										rval: disregard/part plug next subordinate amount
									]
								]
							]

						]
					][
						; we stop observing ALL our subordinates.
						foreach subordinate plug/subordinates [
							if object? subordinate [
								if (found? blk: find subordinate/observers plug) [
									remove blk
								]
							]
							append rval subordinate
						]
						; unlink ourself from all those subordinates
						clear head plug/subordinates
					]

					dirty plug
				]
				oplug: none
				plug: none
				vout
				
				rval
			]


			;--------------------
			;-        insubordinate()
			;
			; remove all of our observers.
			;--------------------
			insubordinate: func [
				"remove all of our observers."
				plug [object!]
				/local observer
			][
				if plug/observers [
					foreach observer copy plug/observers [
						observer/valve/unlink/only observer plug
					]
				]
			]


			;---------------------
			;-        disregard()
			;---------------------
			; this is a complement to unlink.  we ask the engine to remove the observer from
			; the subordinate's observer list, if its present.
			;
			; as an added feature, if the supplied subordinate is within a block, we
			; remove it from that block.
			;---------------------
			disregard: func [
				observer [object!]
				subordinates [object! block!]
				/part amount [integer!] "Only if subordinate is a block!, if amount is 0, nothing happends."
				/local blk iblk subordinate
			][
				either block? subordinates [
					subordinates: copy/part iblk: subordinates any [amount 1]
					remove/part iblk length? subordinates
				][
					subordinates: reduce [subordinates]
				]
				
				foreach subordinate subordinates [
					either object? subordinate [
						either (found? blk: find subordinate/observers observer) [
							remove blk
						][
							to-error rejoin ["liquid/"  type  "[" plug/sid "]/disregard: not observing specified subordinate ( " subordinate/sid ")" ]
						]
					][
						to-error rejoin ["liquid/"  type  "[" plug/sid "]/disregard: supplied subordinates must be or contain objects." ]
					]
				]
				blk: observer: subordinate: iblk: none
				subordinates
			]








			;-----------------------------------------------------------------------------------------------------------
			;
			;-     - PIPING METHODS
			;
			;-----------------------------------------------------------------------------------------------------------
			

			;---------------------
			;-        pipe()
			;---------------------
			; be careful, calling pipe with /always in some cases may be dangerous 
			; (it calls new-pipe which may call us back...).
			;
			;---------------------
			pipe: func [
				"return pipe which should be filled (if any)"
				plug [object!] ; plug to get pipe plug from
				/always "Creates a pipe plug if we are not connected to one"
			][
				
				vin ["liquid/" plug/valve/type "[" plug/sid "]/pipe()"]
				;vprint  either always ["always force pipe"]["container fallback"]
				v?? always
				plug: any [
					all [not always (plug/pipe? = 'container) plug]
					all [(object? plug/pipe?) plug/pipe?]
					all [(plug/pipe? = true) plug]
					all [(plug/pipe? = 'bridge) plug]
					; the plug isn't piped in any way and we want to be sure it always has one.
					all [always plug/valve/new-pipe plug plug/pipe?]
				]
				
				
				vprint [ "returning (sid): [" all [plug plug/sid] "]"]
				vout
				plug
			]
			
			


			;---------------------
			;-        new-pipe()
			;---------------------
			; create a new pipe plug.
			; This is a method, simply because we can easily change what kind of 
			; plug is generated in derived liquid classes.
			;
			; <TO DO>: auto destroy previous pipe if its got no more observers?
			;---------------------
			new-pipe: func [
				plug [object!]
				/channel ch [word!] "setup a channel directly"
				/using server-base [object!] "enforce a class of pipe-server"
				/local pipe-server
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/new-pipe()"]

				; allocate pipe-server
				; if you want a custom pipe server class, just set it within the base class.
				pipe-server: make any [server-base plug/valve/pipe-server-class] [valve/init self]
				
				
				if none? pipe-server/pipe? [
					pipe-server/pipe?: true ; tells new plug that IT is a pipe server
				]
				
				either 'bridge = pipe-server/pipe? [
					vprint "pipe-server is a BRIDGE"
				][
					vprint "standard mode pipe server"
				]
				
				channel: any [ch plug/channel]
				either channel [
					vprint "CHANNELED pipe-server client"
					; force pipe-server into being a bridge
					pipe-server/pipe?: 'bridge
					
					; this will call define-channel automatically.
					attach/to plug pipe-server channel
				][
					; note that attach will raise an error if you try to attach to a bridge and don't give it a channel.
					attach plug pipe-server ; we want to be aware of pipe changes. (this will also connect the pipe in our pipe? attribute)
				]
				vout
				pipe-server
			]


			;---------------------
			;-        attach()
			;---------------------
			; this is the complement to link, but specifically for piping.
			;---------------------
			attach: func [
				""
				client [object!] "The plug we wish to pipe, can be currently piped or not"
				source [object!] "The plug which is or will be providing the pipe.  If it currently has none, it will be asked to create one, per its current pipe callback"
				/to channel [word!] "if pipe server is a bridge, which channel to attach to"
				/local blk pipe-server
			][
				
				vin ["liquid/" client/valve/type "[" client/sid "]/attach()"]
				;check if observer isn't currently piped into something
				client/valve/detach client
				
				

				; get the pipe we should be attaching to, covers all cases
				; if source doesn't have a pipe, it will get one generated as per its pipe-server-class,
				; that will be returned to us.
				pipe-server: source/valve/pipe/always source
				
				;---
				; CHANGED v1.3.2
				;
				; keep value from pipe-server or pipe-source when a new pipe is created.
				pipe-server/mud: any [source/mud source/liquid]
				
				;vprint [ "pipe-server type: " type? pipe-server/pipe? ]
				;vprobe pipe-server/sid
				
				client/pipe?: pipe-server 
				
				;--------------------
				; ATTENTION
				;--------------------
				; the following line of code must NOT be removed.  
				; when we attach ourself, the pipe-server is often already dirty.  
				;
				; when this is the case, propagation optimisations do no allow it to notify its children
				; because they are supposed to already be dirty.
				;
				; if we where not dirty before attach is attempted, we will never be notified
				; and it creates the situation which breaks up all of liquid because we will never 
				; cleanup (we are not dirty) and filling it will never dirty us (server is already dirty)
				;
				; NB: it took a full day to find this bug... please make sure this comment is followed.
				;---------------------
				client/dirty?: true
				
				
				
				either pipe-server/pipe? = 'bridge [
					; pipe server is a bridge, we MUST supply a channel name
					unless channel [
						to-error "Liquid/attach(): pipe server is a bridge, channel name is required"
					]
					; remember which channel to request on content() call.
					client/channel: channel
					
					; make sure the channel exists on the pipe output
					pipe-server/valve/define-channel pipe-server channel
					either block? blk: select pipe-server/observers channel [
						append blk client
					][
						to-error "Liquid/attach(): pipe server is a bridge, and it was unable to define a channel"
					]
				][
					; a normal pipe broadcasts the same information to everyone on the pipe.
					append pipe-server/observers client
				]
				
				pipe-server/valve/dirty pipe-server
				vout
			]


			;---------------------
			;-        detach()
			;---------------------
			;
			; Unlink ourself from a pipe, causing it to stop messaging us (propagating). 
			; by default the plug will revert to dependency mode after being detached,
			; whatever pipe mode it was in (container, bridge, client)
			;
			; note that the /only refinement ensures that its previous value is preserved
			;
			; <TO DO> ? verify if the pipe server is then orphaned (not serving anyone) and in this case call destroy on it)
			;--------------------
			detach: func [
				plug [object!]
				/only "only unlinks from a pipe server (if any). if plug was piped or filled, it remains a container after. previous pipe value is kept."
				/local pipe channel was-piped? pval
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/detach()"]
				was-piped?: not none? plug/pipe?
				
				; unlink, if any pipe
				if object? plug/pipe? [
					either word? plug/channel [
						if channel: select plug/pipe?/observers plug/channel [
							pval: any [
								all [plug/dirty? plug/mud]
								plug/liquid
							]
							if pipe: find channel plug [
								if only [
									pval: pipe/1/valve/content pipe/1
								]
								remove pipe
							]
						]
					
						plug/channel: none
					][
						if only [
							pval: plug/pipe?/valve/content plug/pipe?
						]
						if pipe: find plug/pipe?/observers plug [
							remove pipe
						]
					]
				]
				either all [
					only
					was-piped?
				][
					plug/pipe?: 'container
					; this MAY be problematic on some nodes with purification,
					; but they should be improved to cope with this feature.
					plug/mud: pval
					
					;we set the value of the pipe we where attached to
					plug/liquid: pval
					
				][
					plug/pipe?: none
				]
				
				
				; make sure dependencies are updated
				plug/valve/dirty plug
				
				
				pipe: plug: pval: none
				vout
			]


			;-----------------
			;-        define-channel()
			;-----------------
			define-channel: func [
				plug [object!]
				channel [word!]
				/data value 
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/define-channel()"]
				; make sure we are piped appropriately.
				either plug/pipe? = 'bridge [
					vprint mold to-lit-word channel
					; cannels are defined directly on the observers, as lists of observers, much like labeled subordinates.
					;
					; ex: [observers: [r [0] g [255] b [0] rgb [0.255.0]]]
					;
					; is the channel defined?
					unless block? blk: select plug/observers channel [
						append plug/observers reduce [channel copy []]
					]
					if data [
						plug/valve/fill/channel plug :value channel
					]
				][
					to-error "liquid/define-channel: cannot define channel, pipe server is not a bridge"
					; new-pipe will actually call define-channel via the attach/channel call, which calls us.
					; but it won't result in an endless loop, since by then (plug/pipe? = 'bridge) and our alternate block will trigger instead.
					;plug/valve/new-pipe/channel plug channel
				]
				vout
			]
			
			


			
			
			;-----------------
			;-        on-channel-fill()
			; 
			; this is required by some bridges because there is interdependencies
			; between channels which aren't simple equivalents.
			;
			; the color example is a prime candidate since filling just a channel
			; will invariably depend on the "current" color.
			;
			; the current color may depend on a variety of sequenced fill calls, which might
			; not have been processed between calls to fill, because of lazyness.
			;
			; when called, mud is guaranteed to exist, so can be quickly retrived with:  data: first second plug/mud
			;-----------------
			on-channel-fill: func [
				pipe-server [object!]
			][
				vin [{on-channel-fill()}]
				; does nothing by default.
				data: first second pipe-server/mud
				v?? data
				vout
			]
			
			
			

			;---------------------
			;-        fill()
			;---------------------
			; If plug is not linked to a pipe, then it 
			; automatically connects itself to a new pipe.
			;---------------------
			fill: func [
				"Fills a plug with liquid directly. (stored as mud until it gets cleaned.)"
				plug [object!]
				mud ; data you wish to fill within plug's pipe
				/pipe "<TO DO> tells the engine to make sure this is a pipe, only needs to be called once."
				/channel ch "when a client sets a channel, it is sent to bridge using /channel name"
				/local pipe-server
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/fill()"]

				; revised default method creates a container type plug, instead of a pipe.
				; usage indicates that piping is not always needed, and creates a processing overhead
				; which is noticeable, in that by default, two nodes are created and filling data needs
				; to pass through the pipe.  in most filling ops, this is not usefull, as all the
				; plug is used for is storing a value.
				;
				; a second reason is that from now on a new switch is being added to the plug,
				; so that plugs can be containers and still be linked.  this can simplify many types
				; of graphs, since graphs are often refinements of prior nodes.  so in that optic,
				; allowing us to use data and then modifying it according to local data makes
				; a lot of sense.
				
				
				; set channel to operate on. (none! by default)
				channel: any [ ch plug/channel ]
				
				;?? channel
				
				
				; NOTE: we enforce bridge pipe mode automatically when filling to a channel
				;       the channel will then be automatically created in the bridge.
				;
				; note that if the pipe-class-server doesn't really manage bridges, then 
				; it is re-built as a simple !plug server which, by default, returns stored values 
				; as if they where storage fields.  no processing or inter channel 
				; signaling will occur.  but all attached plugs will be propagated to.
				either channel [
					vprint "CHANNELED Fill"

					; if channel was supplied manually, apply it to plug right now.
					plug/channel: channel		
				
					vprobe plug/channel
					; make sure your pipe-server-class is a bridge
					; it will also make sure that a channel with plug/channel exists.
					pipe-server: plug/valve/pipe/always plug
					
					unless all [
						object? pipe-server: plug/pipe?
						pipe-server/pipe? = 'bridge
					][
						vprint "REPLACING PIPE SERVER WITH A !PLUG BRIDGE"
						plug/valve/new-pipe/channel/using plug channel !plug
					]
					pipe-server: plug/pipe?
				
					unless pipe-server/pipe? = 'bridge [
						to-error "liquid/fill(): cannot fill a channel, pipe is not bridged"
						
						; this is EVIL, but ensure liquid stability.
						; from this point on, the pipe server can only be attached to by channeled pipe clients.
						;
						; it also means that custom pipe servers not expecting to be used as bridges may CORRUPT
						; the liquid.
						;
						; the default plug, though, will hapilly return the channel as-is, so this default behaviour
						; is quite usefull.
						plug/pipe?: 'bridge
					]
					
					vprint "Defining Channel"
					;pipe-server/valve/define-channel pipe-server channel
					
					; in bridge-mode we need to remember WHO signals data, cause each
					; data source is interpreted differently by the bridge process()
					pipe-server/mud: reduce [channel reduce [mud]]
					
					pipe-server/valve/on-channel-fill pipe-server
				][
					;--------------------------
					; unchanneled fill
					;--------------------------
					; be carefull, if your pipe-class-server is a bridge and the plug doesn't have its 
					; channel set, an error will be raised eventually, since the bridge will require a channel name.
					pipe-server: any [
						; enforce this to be a pipe
						all [pipe plug/valve/pipe/always plug]
						
						; get our pipe (or ourself)
						all [plug/valve/pipe plug]
						
						; or convert this plug into a simple container
						all [plug/pipe?: 'container plug]
					]
					
					if pipe-server/pipe? = 'bridge [
						to-error "liquid/fill(): pipe-server is a bridge but no fill channel was specified"
					]
					pipe-server/mud: mud
				]
				pipe-server/valve/dirty pipe-server
				;plug/valve/dirty plug
				vout
				
				;probe pipe-server/mud
				
				; just a handy shortcut for some uses.
				mud
			]


			;-----------------------------------------------------------------------------------------------------------
			;
			;-    - MESSAGING METHODS
			;
			;-----------------------------------------------------------------------------------------------------------
			
			
			
			
			;-----------------
			;-        notify()
			;
			; a high-level function used to make sure any dependencies are notified of our changed state(s)
			;
			; sometimes using fill when the value is the same or just modified is overkill.
			;
			; this should be called instead of dirty() from the outside, since it will adapt to the plug being 
			; a pipe (or not) automatically without causing a refresh deadlock or infinite recursion.
			;
			; note, this doesn't work with bridged clients yet.  since they depend on fill's channel handling.
			;-----------------
			notify: func [
				plug
			][
				plug: any [
					plug/valve/pipe plug ; returns pipe, container or none
					plug
				]
				;probe type? plug/pipe?
				plug/valve/propagate plug
			]
			
			


			;---------------------
			;-        dirty()
			;---------------------
			; react to our link being set to dirty.
			;---------------------
			dirty: func [
				plug "plug to set dirty" [object!]
				/always "do not follow stainless? as dirty is being called within a processing operation.  prevent double process, deadlocks"
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/dirty()"]
				; being stainless? forces a cleanup call right after being set dirty...
				; use this sparingly as it increases average processing and will slow
				; down your code by forcing every plug to process all changes,
				; all the time which is not needed unless you nead interactivity.
				;
				; it can be usefull to set a user observed plug so that any
				; changes to the plugs, gets refreshed in an interactive UI..
				vprint "DIRTY"
				
				either all[
					plug/stainless?
					not always
				][
					plug/dirty?: true
					cleanup plug
					if propagate? plug [
						propagate plug
					]
				][
					if propagate? plug [
						propagate/dirty plug
					]
				]
				
				; clean up
				plug: none
				vout
			]





			;---------------------
			;-        instigate()
			;---------------------
			;
			; Force each subordinate to clean itself, return block of values of all links.
			;
			; v1.0.2 - instigate semantic change.  
			;
			;  -instigate now ignores links when the node is piped
			;  -pipe? now manages 3 different modes.  it would be wasted to handle it in cleanup AND in instigate.
			;
			; following method does not cause subordinate processing if they are clean :-)
			;---------------------
			instigate: func [
				""
				plug [object!]
				/local subordinate blk
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/instigate()"]
				blk: copy []
				if linked? plug [
					;-------------
					; piped plug
					either object? plug/pipe? [
						; ask pipe server to process itself
						append/only blk (plug/pipe?/valve/cleanup plug/pipe?)
					][
						;-------------
						; linked plug
						; force each input to process itself.
						foreach subordinate plug/subordinates [
							switch/default type?/word subordinate [
								object! [
									append/only blk  subordinate/valve/cleanup subordinate
								]
								word! [
									; here we make the word pretty hard to clash with. Just to make instigation safe.
									; otherwise unobvious word useage clashes might occur, 
									; when actual data returned by links are words
									; use objectify func for easier (slower) access to this block
									append/only blk to-word rejoin [subordinate '=]
								]
								none! [
									append blk none
								]
							][
								to-error rejoin ["liquid sid: [" plug/sid "] subordinates block cannot contain data of type: " type? subordinate]
							]
						]
					]
					
					; clean up
					subordinate: none
					plug: none
				]
				; clean return
					
				vout
				blk
			]


			;-----------------
			;-        propagate?()
			;-----------------
			; should this plug perform propagation?
			; some optmized nodes can take advantage of linkeage data, streaming, internal
			; states to forego of propagation to observers, which greatly enhances efficiency
			; of a network.
			;-----------------
			propagate?: func [
				plug
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/propagate?()"]
				vprint ["dirty?  " plug/dirty? ]
				vprint ["frozen? " plug/frozen? ]
				do?: not not all [
					not plug/dirty? 
					not plug/frozen?
				]
				
				v?? do?
				vout
				
				do?
			]
			
			



			;---------------------
			;-        propagate()
			;---------------------
			; cause observers to become dirty
			;---------------------
			propagate: func [
				plug [object!]
				/dirty "set us to dirty at time of propagation, dirty calls us with this flag"
				/local observer observers
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/propagate()"]
				;unless plug/dirty? [ask "propagate clean"]
				;if plug/dirty? [return]
				;prin "."
				
				
				; tell our observers that we have changed
				; some plugs will then process (stainless), other will
				; just acknowledge their dirtyness and return.
				;
				; v0.5 change
				; do not dirty the node if it is piped and we are not its pipe.
				;
				; v0.6 change:
				; now supports linked-containers (was a lingering bug) where they would never get dirty
				; 
				; v0.7 extension:
				; support frozen?
				;
				; v1.0.1
				; we don't propagate if already dirty, an immense processing optimisation.
				;
				; v1.0.2 
				; rebuilt the whole algorithm, added support for bridged pipes
				;
				; v1.1.1
				; fix standard pipe propagation which was broken!
				vprint "propagate?"
				vprobe plug/dirty?
				vprobe plug/frozen?
				;if [
					vprint "propagating..."
					if dirty [
						plug/dirty?: true
					]
					switch/default plug/pipe? [
						bridge [
							foreach [ channel observers ] plug/observers [
								foreach observer observers [
									; make sure we ignore piped clients which aren't part of that pipe
									; its actually a linking error.
									if any [
										none? observer/pipe?
										same? plug observer/pipe?
									][
										observer/valve/dirty observer
									]
								]										
							]
						]
						
						#[true] [
							vprint "PROPAGATING PIPE SERVER!@"
							foreach observer plug/observers [
								; make sure we ignore piped clients which aren't part of that pipe
								; its actually a linking error.
								if any [
									none? observer/pipe?
									same? plug observer/pipe?
								][
									observer/valve/dirty observer
								]
							]
						]
					][
						foreach observer plug/observers [
							observer/valve/dirty observer
						]
					]
						
				;]
				vout
			]


			;----------------------
			;-        stream()
			;----------------------
			; v0.8.0 new feature.
			; this allows a node to broadcast a message just like propagation, but
			; instead of handling container dirtyness, an acutal message packet is 
			; sent from node to node depth first, in order of observer links
			;
			; any node down the chain can inspect the message and decide if he wants 
			; to handle it.  in such a case, he will decide if the handling may
			; interest children or not. he may mutate the message, or add a return element
			; to it, and simply return. any node which detects the return element in the
			; message must simply stop propagating the message, cause it has been detected
			; and is a single point reply (only one node should reply).
			;
			; in the case where the stream is meant as an accumulator, the return message 
			; may simply include a new element which starts by 'return- (ex: 'return-size)
			; this will not provoke an arbitrary propagation end.
			;
			; it is good style (and actually suggested) that you use the plug's type name
			; within the message element and accumulator-type return values because 
			; it ensures the element names does not conflict with other plug authors msg.
			;
			; the stream message format is as follows.
			;
			; [ ; overall container
			;     'plugtype [plug/sid 'tag1: value1 'tag2: value2 ... 'tagN: valueN ] ; first message packet
			;     'plugtype [plug/sid 'tag1: value1 'tag2: value2 ... 'tagN: valueN ] ; second  message packet
			;     'plugtype [plug/sid 'tag1: value1 'tag2: value2 ... 'tagN: valueN ] ; third  message packet
			;     ...
			;     'return [return-plug/sid 'tag1: value1 'tag2: value2 ... 'tagN: valueN ]  ; return message (only one)
			; ]
			;
			; using the sid instead of a plug pointer limits the probability of memory sticking 
			; within the GC, uses less ram, and is MUCH more practical cause you can print the message.
			;
			;
			; RETURNS true if streaming should end
			;----------------------
			stream: func [
				plug [object!]
				msg [block! ] "Msg is SHARED amongst all observers"
				/init "Contstruct the initial message using msg as the message content"
				/as name "Alternate name for the message packet label (only used with init)"
				/depth dpt "Only go so many observers deep."
				/local end?
			][
				end?: false
				if init [
					name: any [name plug/valve/type]
					insert head msg plug/sid 
					msg: reduce [name msg]
				]
				; on-stream returns true if we should end streaming.
				either plug/valve/on-stream plug msg [
					end? true
				][
					either plug/frozen? [
						end? true
					][
						dpt: any [dpt - 1 1024]
						
						if dpt >= 0 [
							; we just reuse the init word, to s0ve from allocating an extra word for nothing
							foreach init plug/observers [
								if init/valve/stream/depth init msg dpt [
									end?: true
									exit ; stop looking for the end, we got it.
								]
							]
						]
					]
				]
				
				; end streaming?
				end?
			]
			
			;---------------------
			;-        on-stream()
			;----------------------
			; 
			;----------------------
			on-stream: func [
				plug [object!]
				msg [block! ]
			][
				
				; end streaming?
				false
			]
			
			
			
			;-----------------------------------------------------------------------------------------------------------
			;
			;-     - COMPUTING METHODS
			;
			;-----------------------------------------------------------------------------------------------------------
			


			;---------------------
			;        filter()
			;---------------------
			; this is a very handy function which influences how a plug processes.
			;
			; basically, the filter analyses any expectations about input connection(s).  by looking at the 
			; instigated values block it receives.
			;
			; it will then return a block of values, if expectations are met. Otherwise, 
			; it returns none and computing does not occur afterwards.
			;
			; note that you are allowed to change the content of the block, by adding values, removing,
			; changing them, whatever.  The only requirement is that process must use the filtered values as-is.
			;
			; note that if a plug is piped, this function is never called.
			;
			; in the case of resolve-links? the function is now called, and so you can fix it as normal.
			;
			; eventually, returning none might force purify to propagate the stale state to all dependent plugs
			;
			; v1.0.2 deprecated
			;---------------------
;			filter: func [
;				plug [object!] "plug we wish to handle."
;				values [block!] "values we wish to filter."
;				/local tmpplug
;			][
;				if object? plug/pipe? [to-error "FILTER() CANNOT BE CALLED ON A PIPED NODE!"]
;					
;				; Do not forget that we must return a block, or we wont process.
;				;
;				; <FIXME>:  add process cancelation in this case (propagate stale?) .
;				values 
;			]




			;---------------------
			;-        process()
			;---------------------
			; process the plug's liquid
			;
			; note that support for the /channel refinement is only required for
			; plugs which become bridge servers.  Only they will call process with
			; a /channel refinement.
			;
			; pipe clients only store which channel they should receive from the bridge,
			; and don't process the channel data as such.
			;---------------------
			process: func [
				plug [object!]
				data [block!] "linked data to process (linked containers include the mud as well)"
				/channel [word!] ch "if this is a bridge, what channel caused processing"
			][
				either ch [
					; empty, safe list
					plug/liquid: []
					vprint "DEFAULT BRIDGE PROCESOR"
				][
					; get our subordinate's liquid
					plug/liquid: pick data 1
				]

			]





			;---------------------
			;-        purify()
			;---------------------
			; purify is a handy way to fix the filled mud, piped data, or recover from a failed process.
			; basically, this is the equivalent to a filter, but AFTER all processing occurs.
			;
			; we can expect plug/liquid to be processed or in an error state, if anything failed.
			;
			; when the plug is a pipe server, then its a chance to stabilise the value before propagating it 
			; to the pipe clients.  This way you can even nullify the fill and reset yourself 
			; to the previous (or any other value).
			;
			; eventually, purify will propagate the stale status to all dependent plugs if it is not
			; able to recover from an error, like an unfiltered node or erronous piped value for this plug.
			;
			; Note that the stale state can be generated within purify if its not happy with the current value
			; of liquid, even if it was called without the /stale refinement.
			;
			; we RETURN if this plug can be considered dirty or not at this point. 
			;---------------------
			purify: func [
				plug [object!]
				/stale "Tells the purify method that the current liquid is stale and must be recovered or an error propagated"
			][
				if stale [
					;print "plug is stale!:"
					; <FIXME> propagate stale state !!!
				]
				;print ["purify: "sid " : " (not none? stale) " " plug/liquid]
				; by default we will only stay dirty if stale was specified.
				; this allows us to make filter blocks which do not process until credentials
				; are met and the plug will continue to try to evaluate until its 
				; satisfied.
				(not none? stale)
			]



			;---------------------
			;-        cleanup()
			;---------------------
			; processing manager, instigates our subjects to clean themselves and causes a process
			; ONLY if we are dirty. no point in reprocessing our liquid if we are already clean.
			;
			; v1.0.3 completely rebuilds the whole function,
			;        it now supports bridges and is faster than previous versions.
			;---------------------
			cleanup: func [
				plug [object!]
				/channel ch [word!]
				/local data oops! mud pipe
			][
				vin ["liquid/" plug/valve/type "[" plug/sid "]/cleanup()"]
				
				vprint ["dirty?  " plug/dirty? ]
				vprint ["frozen? " plug/frozen? ]
				
				if all [
					plug/dirty? 
					not plug/frozen?
				][

;					modes:
;					-----------
;					dependency:  pipe? is none
;					
;					pipe-server:  pipe? is true
;					
;					pipe-client:  pipe? is object
;					
;					bridge-server: pipe? is 'bridge
;
;					bridge-client: pipe? is object + ch is word
;					
;					container: pipe is 'simple
;					
;					linked container: pipe is 'simple + linked-container is true

					;------------------------
					; manage MUD
					;
					; mud is the data set when using fill()
					;------------------------
					;  we verify if we are piped in any way.
					;if pipe: plug/pipe? [
					pipe: plug/pipe?
						;vprint ["plug/pipe is set as: " type? pipe]
						case [
							; a dependency node.
							none? pipe [
								vprint "DEPENDENCY"
								data: plug/valve/instigate plug
								plug/valve/process plug data
							]
							
							; we are a pipe client, get its data
							object? pipe [
								either plug/channel [
									vprint "BRIDGE CLIENT"
									;vprint "channeled client"
									;vprint ["required channel: " plug/channel]
									plug/liquid: pipe/valve/cleanup/channel pipe plug/channel
									;vprint "liquid received: "
									;vprobe plug/liquid
								][
									vprint "STANDARD PIPE CLIENT"
									plug/liquid: pipe/valve/cleanup pipe
								]
							]
							
							; a simple container.
							'container = pipe [
								vprint "CONTAINER"
								
								vprint ["plug/resolve-links?: " plug/resolve-links?]
								;----------------
								; NEW OPTIONS STARTING in v1.2.1
								;------
								switch/default/all plug/resolve-links? [
									LINK-AFTER #[true] [
										data: plug/valve/instigate plug
										data: head insert/only data plug/mud
									]
									LINK-BEFORE [
										data: plug/valve/instigate plug
										data: append/only data plug/mud
									]
									LINK-AFTER  LINK-BEFORE  #[true]  [
										either plug/channel [
											plug/valve/process/channel plug data channel
										][
											plug/valve/process plug data
										]
									]
								][
									;----
									; don't resolve-links
									plug/liquid: plug/mud
								]
								;----------------
								; deprecated in v1.2.1
								;----------------
;								either plug/resolve-links? [
;									data: plug/valve/instigate plug
;									data: head insert/only data plug/mud
;									either plug/channel [
;										plug/valve/process/channel plug data channel
;									][
;										plug/valve/process plug data
;									]
;								][
;									plug/liquid: plug/mud
;								]
							]
							
							
							; this is a pipe server, just use our mud
							true = pipe [
								vprint "PIPE SERVER"	

								;----------------
								; NEW OPTIONS STARTING in v1.2.1
								;------
								switch/default/all plug/resolve-links? [
									LINK-AFTER #[true] [
										data: plug/valve/instigate plug
										data: head insert/only data mud
									]
									LINK-BEFORE [
										data: plug/valve/instigate plug
										data: append/only data plug/mud
									]
									LINK-AFTER  LINK-BEFORE  #[true]  [
										either plug/channel [
											plug/valve/process/channel plug data channel
										][
											plug/valve/process plug data
										]
									]
									
									; starting with v1.3.0
									LINKED-MUD [
										;---
										; does not process, but takes mud from the link, instead of a manual fill.
										data: plug/valve/instigate plug
										plug/liquid: pick data 1
									]
								][
									;----
									; don't resolve-links
									;----
									plug/liquid: plug/mud
								]
								;----------------
								; deprecated in v1.2.1
								;----------------
;								either plug/resolve-links? [
;									data: plug/valve/instigate plug
;									data: head insert/only data plug/mud
;									either plug/channel [
;										plug/valve/process/channel plug data channel
;									][
;										plug/valve/process plug data
;									]
;								][
;									plug/liquid: plug/mud
;								]
								
								
							]
							
							; a bridge server
							'bridge = pipe [
								VPRINT "BRIDGE SERVER"
								;vprint "this is a bridge server"
								; the channel will be used in the process call.
								;
								; if channel is none, we either ignore the change, or use it within process.
								;
								; NOTE: the channel at this point is the last modified (filled) channel, 
								;       NOT a channel supplied to cleanup with /channel ch.
								channel: any [
									all [
										block? plug/mud 
										first plug/mud
									]
									; we provide a default which indicates that it wasn't explicitely set.
									; the actual bridge is responsible for handling this how it wants.
									'*unset
								]
								
								; the channel values are wrapped within blocks to ensure word values aren't mis-interpreted as
								; channel names.  (this is why we use first)
								;mud: first second plug/mud
								mud: any [
									all [
										block? plug/mud
										
										; we return the block, this allows the process to make the difference between
										; a none value and an unset channel eval.
										second plug/mud
									]
									
									; in an unset channel, the plug/mud is undefined, and its the 
									; bridge to manage inconsistencies.
									plug/mud
								]
								
								
								;----------------
								; NEW OPTIONS STARTING in v1.2.1
								;------
								; this is a very advanced setup where the pipe SERVER is ALSO linked !
								switch/default plug/resolve-links? [
									LINK-AFTER #[true] [
										data: plug/valve/instigate plug
										data: head insert/only data mud
									]
									LINK-BEFORE [
										data: plug/valve/instigate plug
										data: head append data mud
									]
									
								][
									;----
									; don't resolve-links
									;----
									data: reduce [mud]
								]
								
								;----------------
								; deprecated in v1.2.1
								;----------------
;								either plug/resolve-links? [
;									data: plug/valve/instigate plug
;									data: head insert/only data mud
;								][
;									data: reduce [mud]
;								]
								
								
								
								
								; process the channels if required
								plug/valve/process/channel plug data channel
								
								;vprint "RESULT: "
								;vprobe plug/liquid
							]
						]
					;]
					
;					; instigate links ?
;					either any [
;						; simple dependency node
;						none? pipe
;						
;						; force processing even when used as part of container/pipe/bridge
;						plug/resolve-links?
;					][
;						vprint "LINKS TO RESOLVE"
;						; force dependency cleanup
;						data: plug/valve/instigate plug
;					][
;						; simple piping just sets the value within the client.
;						plug/liquid: mud
;					]
;
;					if data [
;						if pipe [
;							data: head insert/only data mud
;						]
;						
;						; process is responsible for playing with liquid
;						plug/valve/process plug data
;					]
;


					;------
					; allow a node to fix the value within plug/liquid to make sure its always within 
					; specs, no matter how its origin (or lack thereoff)
					;------
					;print "^/----->:"
					plug/dirty?: plug/valve/purify plug

					; this has to be set AFTER purify
					if all [
						plug/resolve-links? 
						in plug 'previous-mud
					][
						; allows you to compare new value, possibly to ignore multiple fill with different data
						plug/previous-mud: plug/mud
					]
				
				]
				
				rval: either ch [
					;probe "CHANNEL SPECIFIED"
					;if word! =  type? plug/pipe? [
					;	probe plug/pipe?
					;]
					;?? ch
					;probe plug/valve/type
					;probe plug/liquid
					;probe plug/valve/type
					;probe type? plug/liquid
					either function? channel: select plug/liquid ch [
						; this is an optimisation where a liquid will actually not compute
						; all channels at process time, but rather only on demand.
						channel plug
					][
						pick channel 1
					]
				][
					plug/liquid
				]
				vout
				rval
			]



			;---------------------
			;-        content()
			;---------------------
			; method to get plug's processed value, just a more logical semantic value
			; when accessing a liquid from the outside.
			;
			; liquid-using code should always use content, whereas the liquid code itself
			; should always use cleanup.
			;
			; optionally you could redefine the function to make internal/external
			; plug access explicit... maybe for data hidding purposes, for example.
			;---------------------
			content: :cleanup
		]
	]
	
	; we use ourself as the basis for pipe servers by default.
	!plug/valve/pipe-server-class: !plug
]


;------------------------------------
; We are done testing this library.
;------------------------------------
;
; test-exit-slim
;
;------------------------------------


