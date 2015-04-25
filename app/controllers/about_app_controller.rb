class AboutAppController < UIViewController
  def viewDidLoad
    super

    self.title = "About"
    self.view.backgroundColor = UIColor.whiteColor

    webView = UIWebView.new.tap do |v|
      v.frame           = self.view.bounds
      v.scalesPageToFit = true
      # v.backgroundColor = UIColor.whiteColor
      v.delegate        = self
    end
    self.view.addSubview webView

    document = documentHTMLForAbout
    webView.loadHTMLString(document, baseURL: nil)
  end

  def documentHTMLForAbout
    return <<-"EOF"
<!DOCTYPE html>

<html>
<head>
  <title>PokeBu</title>

  <meta charset="utf-8">
  <meta name="format" content="complete">
  <style type="text/css">
    html {
        /* the line height value of 1.9 is fixed for a line height multiple of 1.4 in the text view */
        font: normal 106.2%/1.9 serif;
    }

    body {
        font-family: 'Avenir Next', Helvetica, Georgia, serif;
        word-wrap: break-word;
        margin: 0 0 200px 0;
        padding: 5px;
        border: 0;
        vertical-align: baseline;
        overflow:hidden;
        background-color: #f2f2f2;
        color: #3c3c3c;
    }

    /**
     *
        Wrappers
     *
     */

    #wrapper {
        position: fixed;
        width: 99.9%;
        height: 100%;
        overflow-y: scroll;
        overflow-x: hidden;
        font-size: 2.2em;
    }

    #wrapper::-webkit-scrollbar {
        width: 8px;
        height: 10px;
        -webkit-transition: all .45s ease-in;
        position: relative;
    }
    #wrapper::-webkit-scrollbar-button:start:decrement, #wrapper::-webkit-scrollbar-button:end:increment {
        height: 0px;
        display: block;
        background-color: transparent;
    }
    #wrapper::-webkit-scrollbar-track-piece {
        background-color:
        transparent;
        -webkit-border-radius: 6px;
    }
    #wrapper::-webkit-scrollbar-thumb:vertical {
        height: 50px;
        background-color: #c8c8c8;
        -webkit-border-radius: 6px;
        -webkit-transition: all .45s ease-in;
    }

    #content {
        width: 610px;
        margin: 0 auto 0 auto;
        padding: 30px 0 30px 0;
    }

    /**
     *
        Headings
     *
     */

    h1, h2, h3, h4, h5, h6 {
        text-rendering: optimizeLegibility;
        line-height: 1;
        margin: 0.5rem 0;
    }

    h1, h2, h3, h4, h5, h6 {
        text-rendering: optimizeLegibility;
        line-height: 1;
        margin: 0.5rem 0;
    }

    h1,
    h2,
    h3 { margin-bottom: 1rem; }

    h1 { font-size: 3.25rem; }
    h2 { font-size: 2.75rem; }
    h3 { font-size: 2.25rem; }
    h4 { font-size: 1.75rem; }
    h5 { font-size: 1.5rem; }
    h6 { font-size: 1.35rem; }

    /**
     *
      Paragraphs
     *
     */

    p {
      margin: 0 0 1.5em;
    }

    /**
     *
        Block quotes
     *
     */

    blockquote {
        margin: 0 0 1.5em;
        width: 96%;
        padding: 0 10px;
        border-left: 3px solid #ddd;
        color: #777;
    }

    /**
     *
      Code Blocks
     *
     */

    pre code {
      word-wrap: normal;
      white-space: pre-wrap;
        border: none;
        padding: 0;
        background-color: transparent;
        -webkit-border-radius: 0;
    }

    pre {
      white-space: pre-wrap;
        width: 96%;
        margin-bottom: 24px;
        overflow: hidden;
        padding: 3px 10px;
        -webkit-border-radius: 3px;
        background-color: #eee;
        border: 1px solid #ddd;
    }

    code {
      white-space: nowrap;
      font-family: monospace;
        padding: 2px;
        -webkit-border-radius: 3px;
        background-color: #eee;
        border: 1px solid #ddd;
    }

    small {
      font-size: 65%;
    }

    /**
     *
        Dictionary Definition
     *
     */

    dt {
      display: inline;
        font-weight:bold;
    }

    dd {
      display: block;
    }

    /**
     *
        Anchors
     *
     */

    a {
        color: #308bd8;
        text-decoration:none;
    }
    a:hover {
        text-decoration: underline;
    }

    /**
     *
        Horizontal rules
     *
     */

    hr {
        width: 100%;
        margin: 3em auto;
        border: 0;
        color: #eee;
        background-color: #ccc;
        height: 1px;
        -webkit-box-shadow:0px 1px 0px rgba(255, 255, 255, 0.75);
    }

    /**
     *
        Lists
     *
     */

    ol, ul {
        list-style-position: outside;
        padding-left: 0;
        margin-left: 1.5em;
    }

    ol li, ul li {
        text-align: -webkit-match-parent;
    }

    li p {
        margin: 0.5em 0 0.5em;
    }

    ol ol, ol ul, ul ul, ul ol {
        padding-left: 1.5em;
    }

    /**
     *
        Tables
     *
     */

    table {
        margin-left: auto;
        margin-right: auto;
        margin-bottom: 24px;
        border-bottom: 1px solid #ddd;
        border-right: 1px solid #ddd;
        border-spacing: 0;
    }

    table th {
        padding: 3px 10px;
        background-color: #eee;
        border-top: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    table tr {
    }

    table td {
        padding: 3px 10px;
        border-top: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }

    /**
     *
        Images
     *
     */

    img {
        border: none;
        display: block;
        margin: 1em auto;
        max-width: 100%;
    }

    /**
     *
        Marks
     *
     */

    mark {
        background: #fefec0;
        padding:1px 3px;
    }

    /**
     *
        Footnotes
     *
     */
    .footnote {
        font-size: 0.8rem;
        vertical-align: super;
    }
    .footnotes ol {
        font-weight: bold;
    }
    .footnotes ol li {
        text-align: -webkit-match-parent;
    }

    .footnotes ol li p {
        font-weight: normal;
    }

    /**
     *
        Figures and Captions
     *
     */
    caption {
        font-size: 1.2rem;
        font-weight: bold;
        margin-bottom: 5px;
    }

    figure {
        display: block;
        text-align: center;
    }

    figcaption {
        font-size: 0.8rem;
        font-style: italic;
    }

    /**
     *
        Custom classes
     *
     */

    .shadow {
        -webkit-box-shadow: 0 2px 4px #999;
    }

    .source {
        text-align: center;
        font-size: 0.8em;
        color: #777;
        margin: -40px auto;
    }
    #wrapper {
        width: 99.9%;
    }
    #content {
        width: 840px;
        margin-left: auto;
        margin-right: auto;
    }

    /* Mobile support */
    @media only screen and (max-device-width:1024px) {
        html {
            overflow: auto;
        }

        #wrapper {
            overflow: auto;
            position: relative;
        }
    }@media print {
    /* Printing support.
     * Override all printing colors to match the Light theme.
     */
    img, pre, blockquote, table, figure {
        page-break-inside: avoid;
    }
    body {
        background-color:#fff;
    }
    #wrapper {
        position: static;
        overflow: hidden;
        color: #000;
        width: 100%;
        margin: 0 auto;
    }
    .footnotes {
        page-break-before: always;
    }
    #content {
        margin: 0 auto;
        padding: 0;
        width: 98%;
    }
    #top-fader, #bottom-fader {
        display: none;
    }
    hr {
        color:#ddd;
        background-color:#ddd;
        -webkit-box-shadow:0px 1px 0px #ddd;
    }
    pre {
        background-color:transparent;
        border: 1px solid #ddd;
    }
    code {
        background-color:transparent;
        border: 1px solid #ddd;
    }
    blockquote {
        border-left: 3px solid #ddd;
        color: #000;
    }
    ol {
        /*
         * Override the list style when printing to ensure list
         * markers won't get cut.
         */
        list-style-position: inside;
        padding-left: 0;
        margin-left: 0;
    }
    table {
        border-bottom: 1px solid #ddd;
        border-right: 1px solid #ddd;
    }
    table th {
        background-color:transparent;
        border-top: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }
    table td {
        border-top: 1px solid #ddd;
        border-left: 1px solid #ddd;
    }
    mark {
        background:transparent;
        color: #000;
    }
    .source {
        color: #000;
    }
    }
  </style>
</head>
<body>
  <div id="wrapper">
    <div id="content">
      <h1>PokeBu</h1>

      <p>Pocketに保存したアイテムのリーダーアプリです。</p>

      <p>今のところ、シンプルな機能しかありません。未読記事を消化・アーカイブしながら、はてなブックマークのコメントを閲覧したり、ブックマーク追加したりできます。</p>

      <p>
        自分がよくやっている「Twitterで流れる情報をいったんPocketに保存 => 読了後、はてブ追加・記事のアーカイブ」
        という作業の流れを、モバイル端末でもスムーズに行いたいと思って作りました。
      </p>

      <p>
        ソースコードはRubyMotionを利用して書かれています。
        Naoya Itoさん作のiOSアプリ「HBFav2」を参考にさせていただきました。<br>
        http://hbfav.bloghackers.net
      </p>

      <p>(c) 2015 Yusuke Aono</p>

      <h2>Website</h2>

      <p>http://ysk1031.github.io/Pokebu</p>

      <h2>Developer</h2>

      <p>Yusuke Aono</p>

      <ul>
      <li>Twitter: @ysk_aono
      <li>GitHub: @ysk1031
      </ul>

      <h2>Acknowledgements</h2>

      <p>This App uses the following open source software.</p>

      <h3>AFNetworking</h3>

      <p>Copyright (c) 2013-2015 AFNetworking (http://afnetworking.com/)</p>

      <p>Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the &#8220;Software&#8221;), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:</p>

      <p>The above copyright notice and this permission notice shall be included in
      all copies or substantial portions of the Software.</p>

      <p>THE SOFTWARE IS PROVIDED &#8220;AS IS&#8221;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
      THE SOFTWARE.</p>

      <h3>TTTAttributedLabel</h3>

      <p>Copyright (c) 2011 Mattt Thompson (http://mattt.me/)</p>

      <p>Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the &#8220;Software&#8221;), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:</p>

      <p>The above copyright notice and this permission notice shall be included in
      all copies or substantial portions of the Software.</p>

      <p>THE SOFTWARE IS PROVIDED &#8220;AS IS&#8221;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
      THE SOFTWARE.</p>

      <h3>Hatena-Bookmark-iOS-SDK</h3>

      <p>The MIT License (MIT)</p>

      <p>Copyright (c) 2013 Hatena Co., Ltd.</p>

      <p>Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the &#8220;Software&#8221;), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:</p>

      <p>The above copyright notice and this permission notice shall be included in
      all copies or substantial portions of the Software.</p>

      <p>THE SOFTWARE IS PROVIDED &#8220;AS IS&#8221;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
      THE SOFTWARE.</p>

      <h3>Pocket-ObjC-SDK</h3>

      <p>Copyright (c) 2012 Read It Later, Inc.</p>

      <p>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &#8220;Software&#8221;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:</p>

      <p>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.</p>

      <p>THE SOFTWARE IS PROVIDED &#8220;AS IS&#8221;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>

      <h3>SVWebViewController</h3>

      <p>Copyright (c) 2011 Sam Vermette</p>

      <p>Permission is hereby granted, free of charge, to any person
      obtaining a copy of this software and associated documentation
      files (the "Software"), to deal in the Software without
      restriction, including without limitation the rights to use,
      copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the
      Software is furnished to do so, subject to the following
      conditions:</p>

      <p>The above copyright notice and this permission notice shall be
      included in all copies or substantial portions of the Software.</p>

      <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
      OTHER DEALINGS IN THE SOFTWARE.</p>
    </div>
  </div> <!-- End wrapper -->
</body>
</html>
    EOF
  end
end
