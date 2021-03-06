Class {
	#name : #SpurFileImage,
	#superclass : #SpurImage,
	#instVars : [
		'format',
		'memory',
		'headerSize',
		'dataSize',
		'oldBaseAddress',
		'specialObjectsArrayOop'
	],
	#category : #SpurReader
}

{ #category : #'as yet unclassified' }
SpurFileImage class >> onFile: aFile [

	| memory |
	memory := aFile asFileReference binaryReadStream contents.
	^ self onMemory: memory
]

{ #category : #'as yet unclassified' }
SpurFileImage class >> onMemory: aByteArray [

	^ self basicNew
		memory: aByteArray;
		initialize;
		yourself
]

{ #category : #'as yet unclassified' }
SpurFileImage class >> onMyself [
| memory nilOop VM|
	"nilOop := aSpur32BitMMLESimulator nilObject. 
	memory := aSpur32BitMMLESimulator memory asByteArray.
	memory := fullMemory  copyFrom: nilOop + 1 to: fullMemory size."
	VM = VirtualMachine new.
	  
	^ self basicNew	
		memory: memory;
		version: VM parameterAt: 41;
		headerSize: nilOop;
		specialObjectsArrayOop: VM specialObjectsOop;
		oldBaseAddress: nilOop;
		yourself
]

{ #category : #'as yet unclassified' }
SpurFileImage class >> onSpurSimulator: aSpur32BitMMLESimulator [
	| memory nilOop |
	nilOop := aSpur32BitMMLESimulator nilObject. 
	memory := aSpur32BitMMLESimulator memory asByteArray.
	"memory := fullMemory  copyFrom: nilOop + 1 to: fullMemory size."
	  
	^ self basicNew
		memory: memory;
		headerSize: nilOop;
		specialObjectsArrayOop: aSpur32BitMMLESimulator specialObjectsOop;
		oldBaseAddress: nilOop;
		yourself
]

{ #category : #'special-classes' }
SpurFileImage >> arrayClass [
	"indexInClassTable 51"
	^ self specialObjectsArray slotAt: 8
]

{ #category : #'special-classes' }
SpurFileImage >> byteArrayClass [
	"indexInClassTable 50"
	^ self specialObjectsArray slotAt: 27
]

{ #category : #'special-classes' }
SpurFileImage >> byteStringClass [
	"indexInClassTable 52"
	^ self specialObjectsArray slotAt: 7
]

{ #category : #'special-classes' }
SpurFileImage >> characterClass [
	"indexInClassTable 2"
	^ self specialObjectsArray slotAt: 20
]

{ #category : #'special-objects' }
SpurFileImage >> classTableFirstPage [
	^ self hiddenRootsObj classTableFirstPage
]

{ #category : #'special-objects' }
SpurFileImage >> firstObject [

	^ SpurObject on: headerSize + 1 image: self
]

{ #category : #accessing }
SpurFileImage >> format [ 
	^format
]

{ #category : #'gt-inspector-extension' }
SpurFileImage >> gtInspectorSpecialObjectsArrayIn: composite [
	<gtInspectorPresentationOrder: 1>
	
	^ [(self specialObjectsArray gtInspectorLayoutIn: composite) title: 'SOArray' ] on:Error do: [ 'lalala' ]
]

{ #category : #accessing }
SpurFileImage >> headerSize [

	^ headerSize
]

{ #category : #accessing }
SpurFileImage >> headerSize: anInteger [ 
	headerSize := anInteger
]

{ #category : #accessing }
SpurFileImage >> initialize [

	super initialize.
	self readImageHeader.
]

{ #category : #'special-classes' }
SpurFileImage >> is32bit [
 ^(format = 32) 
]

{ #category : #'special-classes' }
SpurFileImage >> is64bit [
 ^(format = 64) 
]

{ #category : #'special-classes' }
SpurFileImage >> largeNegativeIntegerClass [
	"indexInClassTable 32"
	^ self specialObjectsArray slotAt: 43
]

{ #category : #'special-classes' }
SpurFileImage >> largePositiveIntegerClass [
	"indexInClassTable 33"
	^ self specialObjectsArray slotAt: 14
]

{ #category : #accessing }
SpurFileImage >> memory [
	^ memory
]

{ #category : #accessing }
SpurFileImage >> memory: aCollection [ 
	memory := aCollection
]

{ #category : #'special-classes' }
SpurFileImage >> messageClass [
	"indexInClassTable 35"
	^ self specialObjectsArray slotAt: 16
]

{ #category : #'special-objects' }
SpurFileImage >> nilObject [
	^ self firstObject
]

{ #category : #accessing }
SpurFileImage >> oldBaseAddress [
	^ oldBaseAddress
]

{ #category : #accessing }
SpurFileImage >> oldBaseAddress: anInteger [ 
	oldBaseAddress := anInteger
]

{ #category : #'special-classes' }
SpurFileImage >> pointClass [
	"indexInClassTable 54"
	^ self specialObjectsArray slotAt: 13
]

{ #category : #accessing }
SpurFileImage >> printByteSymbol: aByteSymbolClass [

	^ aByteSymbolClass asLocalByteArray asString reject: [ :e | e = Character null]
]

{ #category : #accessing }
SpurFileImage >> readImageHeader [

"Reading the version will allow us to find the format"
	self readVersionFromImageHeader.
	self is32bit ifTrue:[
		self readImageHeader32 ].
	self is64bit ifTrue:[
		self readImageHeader64 ]
  
]

{ #category : #accessing }
SpurFileImage >> readImageHeader32 [
	| lastHash savedWindowSize headerFlags |
	
	headerSize := (memory copyFrom: 5 to: 8)
		              unsignedLongAt: 1
		              bigEndian: false.
	dataSize := (memory copyFrom: 9 to: 12)
		            unsignedLongAt: 1
		            bigEndian: false.
	self assert: headerSize + dataSize = memory size.
	oldBaseAddress := (memory copyFrom: 13 to: 16)
		                  unsignedLongAt: 1
		                  bigEndian: false.
	specialObjectsArrayOop := (memory copyFrom: 17 to: 20)
		                          unsignedLongAt: 1
		                          bigEndian: false.
	lastHash := (memory copyFrom: 21 to: 24)
		            unsignedLongAt: 1
		            bigEndian: false.
	savedWindowSize := (memory copyFrom: 25 to: 28)
		                   unsignedLongAt: 1
		                   bigEndian: false.
	headerFlags := (memory copyFrom: 29 to: 32)
		               unsignedLongAt: 1
		               bigEndian: false
]

{ #category : #accessing }
SpurFileImage >> readImageHeader64 [
	| lastHash savedWindowSize headerFlags |
	
	headerSize := (memory copyFrom: 5 to: 8)
		              unsignedLongAt: 1
		              bigEndian: false.
	dataSize := (memory copyFrom: 9 to: 16) 
		            unsignedLong64At: 1
		            bigEndian: false.
	self assert: headerSize + dataSize = memory size.
	oldBaseAddress := (memory copyFrom: 17 to: 24)
		                  unsignedLong64At: 1
		                  bigEndian: false.
	specialObjectsArrayOop := (memory copyFrom: 25 to: 32)
		                          unsignedLong64At: 1
		                          bigEndian: false.
	lastHash := (memory copyFrom: 33 to: 40)
		            unsignedLong64At: 1
		            bigEndian: false.
	savedWindowSize := (memory copyFrom: 41 to: 48)
		                   unsignedLong64At: 1
		                   bigEndian: false.
	headerFlags := (memory copyFrom: 49 to: 56)
		               unsignedLong64At: 1
		               bigEndian: false
]

{ #category : #accessing }
SpurFileImage >> readVersionFromImageHeader [
	| version |
	version := (memory copyFrom: 1 to: 4)
		           unsignedLongAt: 1
		           bigEndian: false.
	self flag: #ugly.
	version < 10000
		ifTrue: [  format := 32]
		ifFalse: [  format := 64].
	
]

{ #category : #'special-classes' }
SpurFileImage >> semaphoreClass [
	"indexInClassTable 48"
	^ self specialObjectsArray slotAt: 19
]

{ #category : #'special-classes' }
SpurFileImage >> smallIntegerClass [
	"indexInClassTable 1"
	^ self specialObjectsArray slotAt: 6
]

{ #category : #accessing }
SpurFileImage >> specialObjectsArray [

	^ SpurObject on: specialObjectsArrayOop - oldBaseAddress + headerSize + 1 image: self
]

{ #category : #accessing }
SpurFileImage >> specialObjectsArrayOop: anInteger [ 
	specialObjectsArrayOop := anInteger
]
