# ubuntu搭建Sphinx文档系统

## Sphinx软件安装

根据官网指导，Sphinx可直接通过pip进行安装。

`pip3 install -U Sphinx`

最新的Sphinx软件仅支持python3的安装，非python3用户请安装python3-pip

`sudo apt install python3-pip`





## 快速使用

### 创建example项目

安装完成后即可直接使用：

`sphinx-quickstart`

然后按照指导一步一步填写相关信息。

### 编译成静态页面

`sphinx-build -b html source_dir target_dir`

source_dir: 源文档的目录，即包含conf.py的目录；

target_dir: 生成的静态文件的目标目录，建议设置为nginx的文件目录，方便访问

例：

`sphinx-build -b html . /var/www/html/docs/robot-tools`

### 目录设置

目录设置文件为文档项目目录下的index.rst文件。

参考配置：

```rst
.. robot-tools documentation master file, created by
   sphinx-quickstart on Fri May 29 11:24:04 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

欢迎使用robot-tools文档~
=======================================

.. toctree::
   :maxdepth: 2
   :caption: 文档目录:
   
   documents/test
   documents/cartographer-ros
   documents/ubuntu-16.04-qt-ros

```

### 静态文件

设置conf.py文件

```python
# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['files']
```

files为conf.py目录下的存储静态文件的目录。

## 修改主题

这里我们使用最广泛的ReadTheDocs主题，最新的Sphinx软件已经不再默认自带这个主题了，所以同样需要安装：

`sudo pip3 install sphinx_rtd_theme`

安装好即可使用。



修改主题通过修改conf.py配置文件实现：

```python
# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'
```



## 配置markdown格式文件支持

安装markdown支持软件：

`sudo pip3 install --upgrade recommonmark`

修改配置文件conf.py

```python

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['recommonmark'
]

source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown',
    }

```

## 配置markdown表格支持

```
pip3 install sphinx-markdown-tables
```

配置conf.py文件

```python

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['recommonmark'，'sphinx_markdown_tables'
]

source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown',
    }


```



## 支持pdf导出

安装latex

`sudo apt install texlive-full latexmk`

生成pdf

`make latexpdf`

所生成的pdf文件位于_build/latex/目录下。

> 注意：文档中不得有动图，否则会报错，无法生成pdf。
>



## 参考链接

1. [Sphinx官网](https://www.sphinx-doc.org/en/master/index.html)
2. [markdown支持官方指导](https://www.sphinx-doc.org/en/master/usage/markdown.html)

