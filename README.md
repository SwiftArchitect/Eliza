# Eliza

[![Build Status](https://travis-ci.org/SwiftArchitect/Eliza.svg?branch=master)](https://travis-ci.org/SwiftArchitect/Eliza)
[![CocoaPods](https://img.shields.io/cocoapods/v/Eliza.svg)](https://cocoapods.org/pods/Eliza)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
![MIT License](https://img.shields.io/cocoapods/l/Eliza.svg)

ELIZA is a computer program and an early example of primitive natural language processing. ELIZA operated by processing users' responses to scripts, the most famous of which was DOCTOR, a simulation of a Rogerian psychotherapist. Using almost no information about human thought or emotion, DOCTOR sometimes provided a startlingly human-like interaction. ELIZA was written at MIT by Joseph Weizenbaum between 1964 and 1966.  When the "patient" exceeded the very small knowledge base, DOCTOR might provide a generic response, for example, responding to "My head hurts" with "Why do you say your head hurts?" A possible response to "My mother hates me" would be "Who else in your family hates you?" ELIZA was implemented using simple pattern matching techniques, but was taken seriously by several of its users, even after Weizenbaum explained to them how it worked. It was one of the first chatterbots.

## Example conversation
```
Hi there.
-- so how are you doing today?
not bad, how about yourself?
-- why do you ask?
I am just curious!
-- how long have you been just curious?
etc.
```

## Hi-Level Usage

##### `- (NSString *)talk:(NSString *)text`
Single entry point!
Using the `ChatBot` wrapper, all you need is supply `BBSCHAT.txt` (provided with the project):
```
    // ChatBot * elisa;
    self.eliza = [[ChatBot alloc] init];
```
...and chatting with Eliza looks like this:
```
    // NSSting * input = textField.text;
    NSString * output = [self.eliza talk:input];
```
`ChatBot` is designed to exclusively respond to incoming messages, and never send unsolicited messages. As a result, the first incoming `-talk:` message is ignored, and meerely triggers the greeting.

That's all there is to it.

## Low-Level Usage

If you prefer more control over the Eliza Chatbot, you may use it directly instead of the wrapper class.

##### `[[Eliza alloc] init]`
Creates a new instance of Eliza

##### `- (void)read_script:(NSString *)filePath`
Initializes Eliza with your own script.
Follow original ELIZA script format:
```
; FORMAT:
; Sxxxxxxxxx - DEFINE SIGNON MESSAGE
; Txxxxx
; Txxxxx     - DEFINE PAIR OF WORDS TO TRANSPOSE
; Nxxxxx     - RESPONSE FOR NULL ENTRY
; Mxxxxx     - DEFINE RESPONSE FOR LATER USE OF "MY"
; Xxxxxxx    - DEFINE RESPONSE FOR NO KEYWORD FOUND
; Kxxxxxx    - DEFINE KEYWORD
; Rxxxxxx    - DEFINE RESPONSE FOR PREVIOUS KEYWORD
```

##### `- (NSString *)greet_eliza`
Returns the greeting message. 

##### `- (NSString *)chat_with_eliza:(NSString *)message`
A typical exchange.

