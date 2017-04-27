#!/usr/bin/env python3
#-*-coding:utf-8-*-
import datetime
import codecs
import requests
import os
import re
try:
    import urlparse
except ImportError:
    import urllib.parse as urlparse

from lxml import etree

import config

def cal_start_and_end_date(date, span=6):
    year, month, day = date.split('-')
    cur_day = datetime.datetime(int(year), int(month), int(day))

    prefix_day = cur_day - datetime.timedelta(days=span)
    prefix_day = prefix_day.strftime('%Y/%m/%d')

    postfix_day = cur_day + datetime.timedelta(days=span)
    postfix_day = postfix_day.strftime('%Y/%m/%d')

    return (prefix_day, postfix_day)

def generate_query_str(date, keyword='tesla'):
    prefix_day, postfix_day = cal_start_and_end_date(date)
    print(date, prefix_day, postfix_day)

    query_str = {
        "KEYWORDS": keyword,
        "min-date": prefix_day,
        "max-date": postfix_day,
        "isAdvanced": "true",
        "daysback": "90d",
        "andor": "AND",
        "sort": "date-desc",
        "source": "wsjarticle",
        "page": 1,
    }

    return query_str

def get_headers():
    headers = {
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate, sdch, br',
        'Accept-Language': 'zh-CN,zh;q=0.8,en;q=0.6,ja;q=0.4,zh-TW;q=0.2',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
        'Host': 'www.wsj.com',
        'Pragma': 'no-cache',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
    }
    return headers

def parse_one_page_article_list(data, date=None):
    html = etree.HTML(data)

    total_page = html.xpath(u'//*[@class="results-menu-wrapper bottom"]//*[@class="results-count"]//text()')
    total_page = ''.join(total_page).strip()
    total_page = re.findall('\d+', total_page)
    if not total_page:
        print('NO RESULT', date)
        return (1, set())
    total_page = int(total_page[0])

    urls = set()
    host = 'https://www.wsj.com/'
    article_list = html.xpath(u'//*[@class="search-results-sector"]//@href')
    for al in article_list:
        if '/articles/' in al:
            url = urlparse.urljoin(host, al)
            urls.add(url)

    return (total_page, urls)

def parse_article(data):
    if not data:
        return ('', '')
    
    html = etree.HTML(data)

    cat = html.xpath(u'//*[@class="flashline-category"]//text()')
    cat = ''.join(cat).strip()

    title = html.xpath(u'//*[contains(@class, "wsj-article-headline")]//text()')
    title = ''.join(title).strip()
    
    author = html.xpath(u'//*[@class="byline"]//text()')
    author = ' '.join([x.strip() for x in author]).strip()

    date = html.xpath(u'//*[@class="timestamp"]//text()')
    date = ''.join(date).strip()

    content = html.xpath(u'//*[@id="wsj-article-wrap"]//p/text()')
    content = u'\n'.join([x.strip() for x in content]).strip()

    first_line = u'{cat}/{author}/{date}/{title}'.format(cat=cat, author=author, date=date, title=title)

    return (first_line, content)

def download(url, headers, params=None):
    try:
        r = requests.get(url, headers=headers, params=params)
    except Exception as e:
        print(url, e)
    else:
        return r.text

def parse_date(file='date.txt'):
    with codecs.open(file, 'r', 'utf-8') as f:
        lines = f.readlines()

    lines = [line.strip() for line in lines]

    return lines

def write_file(date, url, first_line, content):
    file_name = date + '.txt'
    with codecs.open(file_name, 'a+', 'utf-8') as f:
        f.write(url + os.linesep)
        f.write(first_line + os.linesep)
        f.write(os.linesep)
        f.write(content + os.linesep)
        f.write(os.linesep)
        f.write('*'*80 + os.linesep)
        f.write(os.linesep)
    

def get_search_result(date, cur_page=1, keyword='tesla'):
    all_urls = set()
    total_page, urls = get_one_page_search_result(date, cur_page, keyword)
    all_urls.update(urls)
    print('TOTAL PAGE:', total_page, 'CURRENT PAGE:', cur_page)

    if total_page > 1:
        while total_page > cur_page:
            cur_page += 1
            total_page, urls = get_one_page_search_result(date, cur_page, keyword)
            all_urls.update(urls)
            print('TOTAL PAGE:', total_page, 'CURRENT PAGE:', cur_page)

    return all_urls

def get_one_page_search_result(date, page=1, keyword='tesla'):
    base_url = "https://www.wsj.com/search/term.html"
    payload = generate_query_str(date, keyword)
    payload['page'] = page
    headers = get_headers()

    data = download(base_url, headers, payload)

    total_page, urls = parse_one_page_article_list(data, date)

    return total_page, urls

def get_article_content(url):
    headers = get_headers()
    cookie = config.cookie
    headers['Cookie'] = cookie

    data = download(url, headers)
    first_line, content = parse_article(data)
    return first_line, content

def get_all_article_content(date, urls):
    for url in urls:
        print('CURRENT URL:', url)
        first_line, content = get_article_content(url)
        write_file(date, url, first_line, content)

def main():
    dates = parse_date()
    for date in dates:
        print('CURRENT QUERY DATE:', date)
        urls = get_search_result(date)
        get_all_article_content(date, urls)

if __name__ == "__main__":
    main()
