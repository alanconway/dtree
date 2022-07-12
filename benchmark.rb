# coding: utf-8
require 'benchmark'
require_relative "dtree"

REGEXS = [
  'Warning|WARN|^W[0-9]+|level=warn|Value:warn|"level":"warn"',
  'Info|INFO|^I[0-9]+|level=info|Value:info|"level":"info"',
  'Error|ERROR|^E[0-9]+|level=error|Value:error|"level":"error"',
  'Critical|CRITICAL|^C[0-9]+|level=critical|Value:critical|"level":"critical"',
  'Debug|DEBUG|^D[0-9]+|level=debug|Value:debug|"level":"debug"',
]

MSGS = [ "", "this is a DEBUG message", "file:line:level=warn", "^C1234 what a mess" ]

N = 1000

def make_dtree
  words = REGEXS.collect { |s| s.split("|")}.flatten.collect do |w|
    w = w.sub("[0-9]+", "💀").chars # replace regexp for digits with 💀
    w.collect { |c| c == :💀 ? :digits : c } # replace 💀 with :digits
  end
  DTree.new(*words)
end

Benchmark.bmbm do |x|
  x.report("multi-regexp") { N.times { MSGS.each { |s| REGEXS.each { |r| s.match r}}}}

  single_regex = "(" + REGEXS.join(")|(") + ")"
  x.report("single-regexp") { N.times { MSGS.each { |s| s.match single_regex}}}

  d = make_dtree
  x.report("dtree") { N.times { MSGS.each { |s| d.find_in(s)}}}
end
