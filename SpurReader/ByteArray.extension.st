Extension { #name : #ByteArray }

{ #category : #'*SpurReader' }
ByteArray >> long64At: index bigEndian: aBool [
	"Return a 64bit unsigned integer quantity starting from the given byte index"
	| b0 b1 b2 w b3 b4 b5 b6 h|
	aBool ifTrue:[
		b0 := self at: index.
		b1 := self at: index+1.
		b2 := self at: index+2.
		b3 := self at: index+3.
		b4 := self at: index+4.
		b5 := self at: index+5.
		b6 := self at: index+6.
		w := self at: index+7.
	] ifFalse:[
		w := self at: index.
		b6 := self at: index+1.
		b5 := self at: index+2.
		b4 := self at: index+3.
		b3 := self at: index+4.
		b2 := self at: index+5.
		b1 := self at: index+6.
		b0 := self at: index+7.
	].
	"Minimize LargeInteger arithmetic"
	h := ((b0 bitAnd: 16r7F) - (b0 bitAnd: 16r80) bitShift: 8) + b1.
	b6 = 0 ifFalse:[w := (b6 bitShift: 8) + w].
	b5 = 0 ifFalse:[w := (b5 bitShift: 16) + w].
	b4 = 0 ifFalse:[w := (b4 bitShift: 24) + w].
	b3 = 0 ifFalse:[w := (b3 bitShift: 32) + w].
	b2 = 0 ifFalse:[w := (b2 bitShift: 40) + w].
	h = 0 ifFalse:[w := (h bitShift: 48) + w].
	^w
]

{ #category : #'*SpurReader' }
ByteArray >> unsignedLong64At: index bigEndian: aBool [
	"Return a 64bit unsigned integer quantity starting from the given byte index"
	| b0 b1 b2 w b3 b4 b5 b6 |
	aBool ifTrue:[
		b0 := self at: index.
		b1 := self at: index+1.
		b2 := self at: index+2.
		b3 := self at: index+3.
		b4 := self at: index+4.
		b5 := self at: index+5.
		b6 := self at: index+6.
		w := self at: index+7.
	] ifFalse:[
		w := self at: index.
		b6 := self at: index+1.
		b5 := self at: index+2.
		b4 := self at: index+3.
		b3 := self at: index+4.
		b2 := self at: index+5.
		b1 := self at: index+6.
		b0 := self at: index+7.
	].
	"Minimize LargeInteger arithmetic"
	b6 = 0 ifFalse:[w := (b6 bitShift: 8) + w].
	b5 = 0 ifFalse:[w := (b5 bitShift: 16) + w].
	b4 = 0 ifFalse:[w := (b4 bitShift: 24) + w].
	b3 = 0 ifFalse:[w := (b3 bitShift: 32) + w].
	b2 = 0 ifFalse:[w := (b2 bitShift: 40) + w].
	b1 = 0 ifFalse:[w := (b1 bitShift: 48) + w].
	b0 = 0 ifFalse:[w := (b0 bitShift: 56) + w].
	^w
]
