NLPResource
=========================

:date: 2009-05-22 02:05:44
:tags: Python, Datamining


有关NLP的资源, 主要使用的是python的nltk工具包

Rescource
-----------------

* Getting Started on Natural Language Processing with Python
* Natural Language Toolkit
* Charming Python: Get started with the Natural Language Toolkit


Natural Language Processing/Some definitions
-----------------------------------------------------

* Token 分词, 这里主要指一个一个词单元
* Sentence 有顺序的词单元序列
* Tokenization 分词技术
* Corpus 词集, Brown Corpus等
* Part-of-speech(POS) tag
* Parse tree 主要是语法解析树


the basic terminology
-----------------------------------------------------

* POS tagging 词性标注
* Computational morphology is concerned with the discovery and analysis of the internal structure of words using computers.
* Parsing: 解析器通过某复杂的统计模型自动推断出一解析树
* Machine translation(MT): most difficult task


NLTK介绍
-----------------------------------------------------

* Brown词集, 标准的Brown词集, 还有领域内的, 另外还有人工词性标注后的词集
* Gutenberg词集, 大概有1.7million词.
* Stopwords corpus, 停用词集, 包含多种语言版本


Task 1: Exploring Corpora
-----------------------------------------------------

词集使用示例

    ::

        >>> from nltk.corpus import gutenberg
        >>> print gutenberg.items
        __main__:1: DeprecationWarning:
          Function _get_items() has been deprecated.  Use corpus.files()
          instead
        ('austen-emma.txt', 'austen-persuasion.txt', 'austen-sense.txt', 'bible-kjv.txt', 'blake-poems.txt', 'chesterton-ball.txt', 'chesterton-brown.txt', 'chesterton-thursday.txt', 'melville-moby_dick.txt', 'milton-paradise.txt', 'shakespeare-caesar.txt', 'shakespeare-hamlet.txt', 'shakespeare-macbeth.txt', 'whitman-leaves.txt')
        >>> print gutenberg.files()  ## 使用files()
        ('austen-emma.txt', 'austen-persuasion.txt', 'austen-sense.txt', 'bible-kjv.txt', 'blake-poems.txt', 'chesterton-ball.txt', 'chesterton-brown.txt', 'chesterton-thursday.txt', 'melville-moby_dick.txt', 'milton-paradise.txt', 'shakespeare-caesar.txt', 'shakespeare-hamlet.txt', 'shakespeare-macbeth.txt', 'whitman-leaves.txt')

        >>> from nltk.probability import FreqDist
        >>> fd = FreqDist()
        >>> for word in gutenberg.words("austen-persuasion.txt"):  ## 原文中的raw得到的是每个字符, 每个单词应该使用words
        ...     fd.inc(word)
        ...
        >>> print fd.N()  ##　所有单词数目
        98171
        >>> print fd.B()　##　唯一单词数目
        6132
        >>> ss = fd.sorted()
        >>> for word in ss[:5]:
        ...     print word, fd[word]
        ...
        , 6750　　　　　　　　　　　##　单词及其出现次数
        the 3120
        to 2775
        . 2741
        and 2739

接下来讲了Zipf定律,,关于词频和位置的关系,,,主要是说明, 人类普遍使用的词占整个词集的少数词, 即是there are a few words that are very common, a few that occur with medium frequency, and a very large number of words that occur very rarely.

    ::

        >>> from nltk import corpus
        >>> from nltk.probability import FreqDist
        >>> from nltk.draw.plot import Plot
        >>> fd = FreqDist()
        >>> for text in corpus.gutenberg.files():　　　## 统计词集
        ...     for word in corpus.gutenberg.words(text):
        ...         fd.inc(word)
        ...
        >>> ss = fd.sorted()
        >>> points = []
        >>> for index, word in enumerate(ss):
        ...     points.append((index+1, fd[word]))   ## 获得位置, 和频数的坐标, 即rank-frequent
        ...
        >>> Plot(points, scale='log').mainloop()  ## 出现了一条log-log曲线, 斜率接近于-1的直线. 是符合zipf定律中的.


Task 2: Predicting Words
-----------------------------------------------------

这个例子用于预测上下文, 使用之前2, 3或多个词进行当前词的预测.

::

    >>> from nltk.corpus import gutenberg
    >>> from nltk.probability import ConditionalFreqDist
    >>> from random import choice
    >>> cfd = ConditionalFreqDist()  ## 使用的是条件频率分布
    >>> prev_word = None
    >>> for word in gutenberg.words("austen-persuasion.txt"):
    ...     cfd[prev_word].inc(word)
    ...     prev_word = word
    ...
    >>> word = 'therefore'
    >>> i = 1
    >>> while i < 20:
    ...     print word,
    ...     lwords = cfd[word].samples()  ## 随机取所有可能的
    ...     follower = choice(lwords)
    ...     word = follower
    ...     i += 1
    ...

therefore lost one of bodily weakness and present she came away some natural course ," said no flagrant open

这个例子只使用前一个单词, 可以使用更多的单词,,,,


Task 3: Discovering Part-Of-Speech Tags
-----------------------------------------------------

分析Brown词集中单词词性, Brown词集有个(token, tag)版本

::

    >>> from nltk.corpus import brown
    >>> from nltk.probability import FreqDist, ConditionalFreqDist
    >>> fd = FreqDist()
    >>> cfd = ConditionalFreqDist()
    >>> for sentence in brown.tagged_sents():  ## 获取所有句子的单词, 词性标注
    ...     for (token, tag) in sentence:
    ...         fd.inc(tag)                    ## 统计词性使用个数
    ...         cfd[token].inc(tag)            ## 统计某单词的词性使用个数
    ...
    >>> fd.max()                               ## 词性使用次数最多的
    'NN'
    >>> wordbins = []
    >>> for token in cfd.conditions():         ## 获得的是(某单词的不同词性个数, 单词)列表
    ...     wordbins.append((cfd[token].B(), token))
    ...
    >>> wordbins.sort(reverse=True)
    >>> print wordbins[0]                      ## 具有最多词性种类的单词
    (12, 'that')
    >>> male = ['he', 'his', 'him', 'himself']
    >>> female = ['she', 'hers', 'her', 'herself']
    >>> n_male = 0
    >>> n_female = 0
    >>> for m in male:
    ...     n_male += cfd[m].N()               ## 男性单词的所有个数
    ...
    >>> for f in female:
    ...     n_female += cfd[f].N()
    ...
    >>> print float(n_male)/n_female
    3.27108476755
    >>> n_ambiguous = 0
    >>> for (ntags, token) in wordbins:       ## 具有不同种类词性的单词个数
    ...     if ntags > 1:
    ...         n_ambiguous += 1
    ...
    >>> n_ambiguous
    8729


Task 4: Word Association
-----------------------------------------------------

共现率(co-occurrences)来衡量单词之间的关联程度

.. sourcecode:: python

    from nltk.corpus import brown, stopwords
    from nltk.probability import FreqDist, ConditionalFreqDist
    fd = FreqDist()
    cfd = ConditionalFreqDist()
    stopwords_list = list(stopwords.raw('english')) ## 获取英文停用词表
    def is_noun(tag):
        return tag in ['NN', 'NNS', 'NN$', 'NN-TL', 'NN+BEZ', 'NN+HVZ', 'NNS$', 'NP', 'NP$', 'NP+BEZ', 'NPS', 'NPS$', 'NR', 'NRS', 'NR$']

    for sentence in brown.tagged_sents():                  ## 外层for运行时间很长
        for (index, tagtuple) in enumerate(sentence):
            (token, tag) = tagtuple
            token = token.lower()
            if token not in stopwords_list and is_noun(tag):
                window = sentence[index+1:index+5]         ## 后5个单词,,,窗口
                for (window_token, window_tag) in window:
                    window_token = window_token.lower()
                    if window_token not in stopwords_list and is_noun(window_tag):
                        cfd[token].inc(window_token)       ## 增加入当前单词的相关单词

    print cfd['bread'].max()  ## cheese
    print cfd['life'].max()   ## death
    print cfd['road'].max()   ## block

There are several other cutting-edge areas in NLP that currently draw a large amount of research activity. It would be informative to discuss a few of them here:

    * Syntax-based machine translation: For the past decade or so, most of the research in machine translation has focused on using statistical methods on very large corpora to learn translations of words and phrases. However, more and more researchers are starting to incorporate syntax into such methods [10].
    * Automatic multi-document text summarization: There are a large number of efforts underway to use computers to automatically generate coherent and informative summaries for a cluster of related documents [8]. This task is considerably more difficult compared to generating a summary for a single document, because there may be redundant information present across multiple documents.
    * Computational parsing: Although the problem of using probabilistic models to automatically generate syntactic structures for a given input text has been around for a long time, there are still significant improvements to be made. The most challenging task is to be able to parse, with reasonable accuracy, languages that exhibit very different linguistic properties when compared to English, such as Chinese and Arabic [7].


Tokenization
-----------------------------------------------------

::

    >>> from nltk.tokenize import WordTokenizer
    >>> WordTokenizer().tokenize("She said 'hello'.")

这里有很多Tokenizer类


Probability
-----------------------------------------------------

主要是使用FreqDist()和ConditionalFreqDist()


stemming
-----------------------------------------------------

提取词干

::

    >>> from nltk.stem.porter import PorterStemmer
    >>> PorterStemmer().stem_word("his")
    'hi'

可以看到有时候提取的词干并不对, 可以使用snallbow或者其他的, 好像之前研究wordnet时也有涉及


Tagging, chunking and parsing
-----------------------------------------------------

tag, 标注
chunk,  这边好几个函数使用还没懂
