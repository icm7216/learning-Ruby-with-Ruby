# encoding:utf-8

# ------------------------------------------------------------------
# Make a EPUB for the "Rubyで学ぶRuby" with Pandoc.
#
# このスクリプトは、遠藤侑介 さんによるアスキーjpの「プログラミング＋」
# コーナーの連載「Rubyで学ぶRuby」からEPUBを作成します。
# 連載url => https://ascii.jp/elem/000/001/230/1230449/
#
# -------------------------------------------------------------------
# My environment:
# Windows 10 64bit, Ruby 2.5.3, pandoc 2.0.4
# mechanize (2.7.6)
# -------------------------------------------------------------------

require 'mechanize'

# epub-stylesheet
EPUB_CSS = 'learning-Ruby-with-Ruby.css'

# output file name
HTML_OUT = 'learning-Ruby-with-Ruby.html'
EPUB_OUT = 'learning-Ruby-with-Ruby.epub'

# target url
target_host = 'https://ascii.jp/elem/000/'
target_domain = 'https://ascii.jp'

target_path = {
  part01: '001/228/1228239/',
  part02: '001/238/1238130/',
  part03: '001/247/1247344/',
  part04: '001/255/1255878/',
  part05: '001/264/1264148/',
  part06: '001/273/1273058/',
  part07: '001/279/1279737/',
  part08: '001/406/1406906/',
  part09: '001/419/1419659/'
}

# HTML header and TOC
all_html = <<HTML
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="author" content="遠藤侑介">
<meta name="language" content="ja">
<meta name="description" content="この書籍は 遠藤侑介 さんによる、アスキーjpの「プログラミング＋」コーナーの連載「Rubyで学ぶRuby」から作成しています。">
<link rel="stylesheet" type="text/css" href="./#{EPUB_CSS}">
<title>Rubyで学ぶRuby</title>
</head>
<body>
<h1>Rubyで学ぶRuby</h1>
<p>この書籍は 遠藤侑介 さんによる、<a href="https://ascii.jp/">ASCII.jp</a> の「プログラミング＋」コーナーの連載「<a href="https://ascii.jp/elem/000/001/230/1230449/">Rubyで学ぶRuby</a>」から作成しています。</p>
<h2 id="toc">目次</h2>
<ul>
  <li><a href="#part01">第1回 Ruby超入門（前編）</a></li>
  <li><a href="#part02">第2回 Ruby超入門 （後編）</a></li>
  <li><a href="#part03">第3回 Rubyで「木」を扱う</a></li>
  <li><a href="#part04">第4回 Rubyで電卓を作る</a></li>
  <li><a href="#part05">第5回 Rubyで変数付き電卓を作ってみる</a></li>
  <li><a href="#part06">第6回 分岐を実装する</a></li>
  <li><a href="#part07">第7回 関数を実装する（前編）</a></li>
  <li><a href="#part08">第8回 関数を実装する（後編）</a></li>
  <li><a href="#part09">第9回 インタプリタの完成、そしてブートストラップへ</a></li>
</ul>
<hr>
<h1>Rubyで学ぶRuby（紙書籍）</h1>
<p>Web連載のコンテンツを、さらにわかりやすく紙版の書籍として再編纂された書籍<a href="https://www.lambdanote.com/collections/ruby-ruby">「RubyでつくるRuby ゼロから学びなおすプログラミング言語入門」</a>が<a href="https://www.lambdanote.com/">技術書出版ラムダノート株式会社</a>より出版されています。</p>
<hr>
HTML


# get contents
agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'
title_list = []

target_path.each do |toc_id, path|
  html = ""
  page = agent.get("#{target_host}#{path}")
  
  post_title = page.at('#articleHead h1').text
  title_list << post_title
  
  # remove lines
  page.css('div.pickwrap').remove
  page.css('div#sideR').remove
  page.css('div.sbmV3').remove 
  page.css('ul.artsCont').remove 
  page.css('div#clubreco').remove 
  page.css('script').remove 
  page.css('h5.feature').remove 
  page.css('h5.related').remove 
  page.css('div.pages pgbottom').remove
  page.css('div#artAds').remove
  page.css('p.twitBtn').remove
  page.css('div.pages').remove
  page.css('p.returnCat').remove
  page.css('img#EndOfTxt2').remove
  
  # remove comment in a colgroup
  colgroup = page.css('colgroup')
  colgroup.each do |x| 
    col_str = x.to_html.gsub(/<!-- No CDATA -->/, '')
    x.swap(col_str)
  end
  
  # fix attribute
  h1_id = page.at('div#articleHead h1')
  h1_id["id"] = "#{toc_id}"
  p_href = page.at('div#articleHead p.sertitle a')
  p_href["href"] = "#toc"

  # fix duplicate identifier
  h2_id = page.css('h2#練習問題')
  h2_id.each {|x| x['id'] = "#{x['id']}_#{toc_id}" if x['id']}
  h3_id = page.css('h3')
  h3_id.each {|x| x['id'] = "#{x['id']}_#{toc_id}" if x['id']}

  # Avoid the influence of "column" of Pandoc
  div_col = page.css('div.column')
  div_col.each {|x| x['class'] = x['class'].sub(/column/, 'col')}



  # remove ID duplication
  page.css('h2#クイズ').remove_attr('id')
  page.css('h2#今回のまとめと次回予告').remove_attr('id')
  page.css('h2#まとめと次回予告').remove_attr('id')
  page.css('h2#まとめ').remove_attr('id')
  page.css('h2#脚注').remove_attr('id')

  # download images
  page.css('img').each do |img|
    begin
      img_src = img.attribute("src").value
      match_list = img_src.match(/\/elem\/000\/.*?([^\/]+(?:(jpg)|(gif)))/)
      if match_list
        img_path = "./img/#{toc_id}/#{match_list[1]}"
        img_url = "#{target_domain}#{img_src}"
        agent.get(img_url).save img_path
        img["src"] = img_path
      end
    rescue Mechanize::ResponseCodeError => e
      puts 'Response Error #{e.response_code}: ' + img_src
    end
  end

  # make HTML contents
  body = page.at('div#mainC').to_html
  html << body
  all_html << html << "</div><hr>\n"

  # progress
  print "o"

  # load reduction for image download
  sleep(5) 
end

all_html << '</body></html>'

# display each title
puts "\nget title =>"
puts title_list.map {|x| x.gsub(/\n+/,'')}

# convert HTML to EPUB
puts "convert HTML to EPUB"

# output HTML
File.open(HTML_OUT, "w"){|w| w.puts all_html }
puts "output HTML => #{HTML_OUT}"

# output EPUB
system("pandoc -f html -t epub #{HTML_OUT} -o #{EPUB_OUT} --css=#{EPUB_CSS}")
puts "output EPUB => #{EPUB_OUT}"





