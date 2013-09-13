REBOL [
	; -- Core Header attributes --
	title: "liquid ink | script manipulation plugs."
	file: %liquid-ink.r
	version: 0.1.0
	date: 2013-9-10
	author: "Maxim Olivier-Adlhoch"
	purpose: {Manage, fix and edit scripts and source code using this collection of liquid plugs.}
	web: http://www.revault.org/modules/liquid-ink.rmrk
	source-encoding: "Windows-1252"
	note: {slim Library Manager is Required to use this module.}

	; -- slim - Library Manager --
	slim-name: 'liquid-ink
	slim-version: 1.2.1
	slim-prefix: none
	slim-update: http://www.revault.org/downloads/modules/liquid-ink.r

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
		2013-9-10 - v0.1.0
			-creation of history.
	}
	;-  \ history

	;-  / documentation
	documentation: {
		User documentation goes here
	}
	;-  \ documentation
]





;--------------------------------------
; unit testing setup (using slut.r)
;--------------------------------------
;
; test-enter-slim 'liquid-ink
;
;--------------------------------------

slim/register [
	
	slim/open/expose 'liquid none [processor]
	
	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- GLOBALS
	;
	;-----------------------------------------------------------------------------------------------------------
	
	 
	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;
	;- CLASSES
	;
	;-----------------------------------------------------------------------------------------------------------
	
	 
	;-                                                                                                         .
	;-----------------------------------------------------------------------------------------------------------
	;- 
	;- PLUGS
	;- 
	;-----------------------------------------------------------------------------------------------------------
	
	;--------------------------
	;-     !split-script -->
	;--------------------------
	; purpose:  split a rebol source script into 3, with the header block as the split region
	;
	; inputs:   a rebol source script in string! format
	;
	; returns:  -a block of three strings, 
	;
	;			-if the input isn't valid, we return a block of three strings with both pre 
	;            header and header set to empty strings, and last item as a string version of input.
	;
	; notes:    the output is all strings, and copies of the input.
	;			
	;
	; tests:    
	;--------------------------
	!split-script: processor '!split-script [
		vin ["!split-script[" plug/sid "]/process()"]
		plug/liquid: any [
			all [
				string? script: pick data 1
				rebol-hdr: find/tail script "REBOL"
				rebol-hdr: find rebol-hdr "[" ; not perfect, should be a proper parse (we can have comments between rebol and the "[", but nothing else.
				block? tmp: load/next rebol-hdr
				;vprobe tmp/2
				reduce [
					copy/part script rebol-hdr
					copy/part rebol-hdr tmp/2
					copy tmp/2
					
				]
			]
			reduce [ "REBOL " "" to-string script ]
		]
		vout
	]
	
	
	
	
	
	
]


;------------------------------------
; We are done testing this library.
;------------------------------------
;
; test-exit-slim
;
;------------------------------------
