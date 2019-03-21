require_relative 'test_helper'

class SeaTest < Minitest::Test
  describe "signal definition" do
    it "inherits ancestor observers" do
      class ParentSignal < Sea::Signal
        emit_to "SeaTest::Mod1"
      end

      class ChildSignal < ParentSignal
        emit_to "SeaTest::Mod2"
      end

      assert_equal ["SeaTest::Mod1"], ParentSignal.send(:observers)
      assert_equal ["SeaTest::Mod1", "SeaTest::Mod2"], ChildSignal.send(:observers)
    end

    it "allows to namespace observers" do
      class NamespacedObserverSignal < Sea::Signal
        emit_to ["Mod1", "Mod2"], in: "SeaTest"
      end

      assert_equal ["SeaTest::Mod1", "SeaTest::Mod2"], NamespacedObserverSignal.send(:observers)
    end

    it "fails to namespace observers when passing const" do
      error = assert_raises ArgumentError do
        class NamespacedObserverCostSignal < Sea::Signal
          emit_to String, in: "SeaTest"
        end
      end

      assert_match "expected namespaced observer name, got: String", error.message
    end

    it "fails to namespace observers on invalid namespace type" do
      error = assert_raises ArgumentError do
        class NamespacedObserverCostSignal < Sea::Signal
          emit_to "Mod1", in: 1
        end
      end

      assert_match "expected namespace name, got: 1", error.message
    end

    it "raises on duplicate observer" do
      error = assert_raises ArgumentError do
        class DuplicateObserverSignal < Sea::Signal
          emit_to "SeaTest::Mod1"
          emit_to "SeaTest::Mod1"
        end
      end

      assert_match "observer \"SeaTest::Mod1\" already added", error.message
    end

    it "raises on invalid observer type" do
      error = assert_raises ArgumentError do
        class InvalidObserverSignal < Sea::Signal
          emit_to 1
        end
      end

      assert_match "expected observer class/module/name, got: 1", error.message
    end
  end

  describe "signal/observer integration" do
    it "works with multiple signals using varying syntax" do
      class SampleSignal < Sea::Signal
        attr_accessor :number_as_string

        emit_to "SeaTest::Mod1"
        emit_to ["SeaTest::Mod2", "SeaTest::Mod3"]

        def initialize(number)
          if number == 1
            @number_as_string = "one"
          else
            @number_as_string = number
          end
        end
      end

      class Mod1 < Sea::Observer
        def handle_signal
          puts("Mod1 got #{signal.number_as_string}")
        end
      end

      class Mod2 < Sea::Observer
        def handle_signal
          puts("Mod2 got #{signal.number_as_string}")
        end
      end

      class Mod3 < Sea::Observer
        def handle_signal
          puts("Mod3 got #{signal.number_as_string}")
        end
      end

      out, _ = capture_io do
        SampleSignal.new(1).emit
      end

      assert_equal (
        "Mod1 got one\n" +
        "Mod2 got one\n" +
        "Mod3 got one\n"
      ), out
    end

    it "raises on missing #handle_signal" do
      class MiscSignal < Sea::Signal
        emit_to "SeaTest::InvalidMod1"
      end

      class InvalidMod1 < Sea::Observer
      end

      error = assert_raises NoMethodError do
        MiscSignal.new.emit
      end

      assert_match "method `handle_signal' not implemented for observer SeaTest::InvalidMod1",
        error.message
    end
  end
end
