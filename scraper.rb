require 'HTTParty'
require 'Nokogiri'
require 'open-uri'

urls = {
    beginner: {
        "Variables, strings & numbers" => "http://www.codequizzes.com/ruby/beginner/variables-strings-numbers",
        "Arrays, conditionals & while loops" => "http://www.codequizzes.com/ruby/beginner/arrays-conditionals-loops",
        "Variable scope and methods" => "http://www.codequizzes.com/ruby/beginner/variable-scope-methods",
        "Symbols, array methods & hashes" => "http://www.codequizzes.com/ruby/beginner/symbols-array-methods-hashes",
        "Intro to OOP" => "http://www.codequizzes.com/ruby/beginner/intro-object-oriented-programming",
        "Iteration and nested data structures" => "http://www.codequizzes.com/ruby/beginner/iteration-nested-data-structures",
        "Modules, classes and inheritance" => "http://www.codequizzes.com/ruby/beginner/modules-classes-inheritance"
    },
    intermediate: {
        "Grokking the Array Class" => "http://www.codequizzes.com/ruby/intermediate/array-methods-practice",
        "Grokking the Hash Class" => "http://www.codequizzes.com/ruby/intermediate/hash-class",
        "OOP - Instance variables, constants, messages" => "http://www.codequizzes.com/ruby/intermediate/instance-variables-constants-self-message-sending",
        "More OOP - Monkey patching, modules" => "http://www.codequizzes.com/ruby/intermediate/monkey-patching-modules-singleton-methods",
        "Inheritance & ancestors" => "http://www.codequizzes.com/ruby/intermediate/inheritance-ancestors-super",
        "Object oriented design" => "http://www.codequizzes.com/ruby/intermediate/object-oriented-design",
        "Code blocks" => "http://www.codequizzes.com/ruby/intermediate/code-blocks"
    },
    advanced: {
        "Singleton classes and methods" => "http://www.codequizzes.com/ruby/advanced/singleton-class-methods-inheritance-method-lookup",
        "Scope Gates, top level context" => "http://www.codequizzes.com/ruby/advanced/scope-gates-top-level-context",
        "Closures and bindings" => "http://www.codequizzes.com/ruby/advanced/closures-bindings",
        "Object Model" => "http://www.codequizzes.com/ruby/advanced/object-model-private-protected",
        "Module Include and Extend" => "http://www.codequizzes.com/ruby/advanced/module-include-extend",
        "Metaprogramming - Method missing" => "http://www.codequizzes.com/ruby/advanced/method-missing-metaprogramming"
    },
    tdd: {
        "String and Integer code for RSpec tests" => "http://www.codequizzes.com/ruby/test-driven-development/strings-integers-tdd",
        "RSpec Array quizz" => "http://www.codequizzes.com/ruby/test-driven-development/rspec-arrays-expectations"
    }
}

class Scraper
    attr_accessor :parse_page

    def initialize(url)
        doc = HTTParty.get(url) 
        @parse_page ||= Nokogiri::HTML(doc) 
    end

    def item_container
        @parse_page.css(".table")
    end

    def get_questions
        item_container.css(".question").map { |question| question.text }.compact
    end

    def get_answers
        item_container.css(".answer").map { |answer| answer.text }.compact
    end
end

urls.keys.each do |key| 
    urls[key].each_with_index do |(k, v), idx| 
        test = Scraper.new(v)
        questions = test.get_questions
        answers = test.get_answers
        File.open("#{key.capitalize} - #{idx+1}. #{k}.txt", 'w') do |file| 
            questions.each_with_index do |q, i|
                file.write("#Question #{i+1}. #{q}")
                file.write("#Answer #{i+1}. " + answers[i])
                file.write("------------------")
                file.write("\n\n")
            end
        end
    end  
end