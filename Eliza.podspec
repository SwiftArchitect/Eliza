Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "Eliza"
  spec.version      = "1.0.0"
  spec.summary      = "Eliza, the 1966 Chat robot written at MIT by Joseph Weizenbaum"
  spec.description  = <<-DESC
                      A faithful implementation of the mother of all chatbots.
                      
                      ELIZA is a computer program and an early example of primitive natural language processing. 
                      ELIZA operated by processing users' responses to scripts, the most famous of which was DOCTOR, a simulation of a Rogerian psychotherapist. 
                      Using almost no information about human thought or emotion, DOCTOR sometimes provided a startlingly human-like interaction. 
                      ELIZA was written at MIT by Joseph Weizenbaum between 1964 and 1966.  
                      When the "patient" exceeded the very small knowledge base, DOCTOR might provide a generic response, for example, responding to "My head hurts" with "Why do you say your head hurts?". A possible response to "My mother hates me" would be "Who else in your family hates you?".
                      ELIZA was implemented using simple pattern matching techniques, but was taken seriously by several of its users, even after Weizenbaum explained to them how it worked.
                      It was one of the first chatterbots.
                      DESC
  spec.homepage     = "https://github.com/SwiftArchitect/Eliza"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author       = { "Xavier Schott" => "http://swiftarchitect.com/swiftarchitect/" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios
  spec.ios.deployment_target = '7.0'
  spec.requires_arc = true

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/SwiftArchitect/Eliza.git", :tag => "v1.0.0" }
  spec.exclude_files = "*.txt"
  spec.source_files = "Eliza/*.{h,m}"
  spec.public_header_files = "Eliza/**/*.h"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.framework = "UIKit"

end

