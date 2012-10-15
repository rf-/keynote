# encoding: UTF-8

# Original Rumble tests (c) 2011 Magnus Holm (https://github.com/judofyr).

require 'helper'

Rumble = Keynote::Rumble

class TestRumble < MiniTest::Unit::TestCase
  include Rumble

  def assert_rumble(html, &blk)
    exp = html.gsub(/(\s+(<)|>\s+)/) { $2 || '>' }
    res = nil
    rumble {
      res = yield.to_s
    }
    assert_equal exp, res
  end

  def setup
    super
    assert_nil @rumble_context
  end

  def teardown
    super
    assert_nil @rumble_context
  end

  def test_simple
    html = <<-HTML
      <html>
      <head>
        <title>Rumble Test</title>
      </head>
      <body>
        <div id="wrapper">
          <h1>My Site</h1>
        </div>
      </body>
      </html>
    HTML

    assert_rumble html do
      html do
        head { title "Rumble Test" }

        body do
          div.wrapper! do
            h1 "My Site"
          end
        end
      end
    end
  end

  def test_capture
    html = <<-HTML
      <p>&lt;br&gt;</p>
    HTML

    assert_rumble html do
      p rumble { br }
    end
  end

  def test_several
    html = <<-HTML
      <p>Hello</p>
      <p>World</p>
    HTML

    assert_rumble html do
      p "Hello"
      p "World"
    end
  end

  def test_several_capture
    html = <<-HTML
      <div>
        <p>Hello</p>
        <p>Hello</p>
        |
        <p>World</p>
        <p>World</p>
      </div>
    HTML

    assert_rumble html do
      div do
        %w[Hello World].map { |x| rumble { p x; p x } } * '|'
      end
    end
  end

  def test_capture_raise
    assert_raises RuntimeError do
      div do
        rumble do
          raise
        end
      end
    end
  end

  def test_escape
    html = <<-HTML
      <p class="&quot;test&quot;">Hello &amp; World</p>
    HTML

    assert_rumble html do
      p "Hello & World", :class => '"test"'
    end
  end

  def test_multiple_css_classes
    html = <<-HTML
      <p class="one two three"></p>
    HTML

    assert_rumble html do
      p.one.two.three
    end
  end

  def test_selfclosing
    assert_rumble "<br>" do
      br
    end
  end

  def test_text
    assert_rumble "hello" do
      text "hello"
    end
  end

  def test_error_selfclosing_content
    assert_raises Rumble::Error do
      rumble {
        br "content"
      }
    end
  end

  def test_error_css_proxy_continue
    assert_raises Rumble::Error do
      rumble {
        p.one("test").two
      }
    end
  end

  # The real test here is if @rumble_context is nil in the teardown.
  def test_error_general
    assert_raises RuntimeError do
      rumble {
        html do
          raise
        end
      }
    end
  end
end
