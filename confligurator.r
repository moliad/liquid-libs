REBOL [
	; -- Core Header attributes --
	title: "liquified configurator"
	file: %confligurator.r
	version: 0.0.1
	date: 2015-6-2
	author: "Maxim Olivier-Adlhoch"
	purpose: "a configurator which you can connect to directly."
	web: http://www.revault.org/modules/confligurator.rmrk
	source-encoding: "Windows-1252"
	note: {slim Library Manager is Required to use this module.}

	; -- slim - Library Manager --
	slim-name: 'confligurator
	slim-version: 1.2.7
	slim-prefix: none
	slim-update: http://www.revault.org/downloads/modules/confligurator.r

	; -- Licensing details  --
	copyright: "Copyright © 2015 Maxim Olivier-Adlhoch"
	license-type: "Apache License v2.0"
	license: {Copyright © 2015 Maxim Olivier-Adlhoch

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
		v0.0.1 - 2015-06-02
			-creation
	}
	;-  \ history

	;-  / documentation
	documentation: ""
	;-  \ documentation
]



;--------------------------------------
; unit testing setup
;--------------------------------------
;
; test-enter-slim 'confligurator
;
;--------------------------------------

slim/register [
	;-                                                                                                       .
	;-----------------------------------------------------------------------------------------------------------
	;
	;-     LIBS
	;
	;-----------------------------------------------------------------------------------------------------------

	slim/open/expose 'configurator none [ !config configure ]
	slim/open/expose 'liquid none [ liquify !plug content fill attach*: attach]

	*get: get in system/words 'get



	;----
	; intermediate, just to store a copy of the set function from the original !config class.
	!-config: make !config [
		config-set: :set
	]


	
	;-                                                                                                       .
	;-----------------------------------------------------------------------------------------------------------
	;
	;-     !CONFLIG
	;
	;-----------------------------------------------------------------------------------------------------------
	
	!conflig: make !-config [
		;--------------------------
		;-         set()
		;--------------------------
		; purpose:  set one of the configurations, using a liquid fill 
		;
		; inputs:   
		;
		; returns:  the input value.
		;
		; notes:    not all refinements are supported in this version of the config tool
		;
		; to do:    
		;
		; tests:    
		;   test [ set confligurator.r]  [ "hoho" = gbl-conf/set 'test "hoho" ]
		;--------------------------
		set: funcl [
			tag [word!]
			value
			/type types [word! block!] "immediately cast the tag to some type"
			/doc docstr [string!] "immediately set the help for this tag"
			/overide "ignores protection, only for use within distrobot... code using the !config should not have acces to this."
			/conceal "immediately call conceal on the tag"
			/protect "immediately call protect on the tag"
		][
			vin [{!config/set()}]
			vprobe tag
			
			
			either all [not overide protected? tag] [
				; <TODO> REPORT ERROR
				vprint/error rejoin ["CANNOT SET CONFIG: <" tag "> IS protected"]
			][
				either function? :value [
					; this is a dynamic tag, its evaluated, not stored.
					vprint/error rejoin ["CONFLIGURATOR does not support functional tags"]
				][
					any [
						in tags tag
						;tags: make tags reduce [load rejoin ["[ " tag ": none ]"]
						self/tags: make self/tags reduce [
							to-set-word tag 
							liquify/fill !plug none
						]
					]
					if space-filled? tag [
						value: to-string value
						parse/all value [any [ [here: whitespace ( change here "-")] | skip ] ]
					]
					
					fill self/tags/:tag :value
				]
			]
			if conceal [
				self/conceal tag
			]
			
			if protect [
				self/protect tag
			]
			
			if doc [
				document tag docstr
			]
			
			if type [
				cast tag types
			]
			
			vout
			value
		]



		
		;--------------------------
		;-         get()
		;--------------------------
		;
		;   test [ get confligurator.r]  [  777 = gbl-conf/get 'test2 ]
		;--------------------------
		get: func [
			tag [word!]
		][
			;vin [{!config/get()}]
			;vprobe tag
			;vout
			either (in dynamic tag) [
				dynamic/:tag
			][
				all [
					plug: *get in tags tag
					content plug
				]
			]
		]
		
		
		;--------------------------
		;-         attach()
		;--------------------------
		; purpose:  attach the config tag TO an external pipe.
		;
		; returns:	internal PLUG we are attaching.  NONE when the tag isn't valid or inexistant.
		;
		; notes:    -we cannot attach to dynamic tags.
		;           -when attaching, we always /PRESERVE our value.
		;
		; tests:    
		;--------------------------
		attach: funcl [
			tag [word!]
			pipe [object!]
		][
			vin "attach()"
			plug: all [
				plug: *get in tags tag
				attach*/preserve plug pipe
				plug
			]
			vout
			
			plug
		]
		
		
		;--------------------------
		;-         get-plug()
		;--------------------------
		; purpose:  retrieve a plug from the config, so we can attach to it dynamically.
		;
		; inputs:   
		;
		; returns:  
		;
		; notes:    
		;
		; to do:    
		;
		; tests:    
		;--------------------------
		get-plug: funcl [
			tag [word!]
		][
			vin "get-plug()"
			plug: all [
				*get in tags tag
			]
			vout
			plug
		]
		
	]
	
	
	;--------------------------
	;-         confligure()
	;--------------------------
	; purpose:  same as configure, but using a !confliguration object instead.
	;
	; inputs:   spec block to use a defaults.
	;
	; returns:  the !conflig object
	;
	; tests:    
	;		test-init [ gbl-conf: confligure [ test: 555 "test documentation" test2: 777 ] ]
	;--------------------------
	confligure: funcl [
		spec [block! none!]
		/cfg confliguration "MUST be a !conflig object... a normal !config object is not supported"
		/no-snapshot
	][
		vin "confligure()"
		config: any [
			confliguration 
			make !conflig []
		]
		
		apply :configure [spec true config no-snapshot]
		
		vout
		config
	]
	

]

;------------------------------------
; We are done testing this library.
;------------------------------------
;
; test-exit-slim
;
;------------------------------------

