FROM ipython/scipystack

MAINTAINER sendit2me

VOLUME /notebooks
WORKDIR /notebooks

EXPOSE 8888

# You can mount your own SSL certs as necessary here
ENV PEM_FILE /key.pem
# $PASSWORD will get `unset` within notebook.sh, turned into an IPython style hash
ENV PASSWORD Dont make this your default
ENV USE_HTTP 0

RUN sudo apt-get -y install freetds-dev

RUN pip2 install --upgrade pip
RUN pip3 install --upgrade pip
RUN pip2 install elasticsearch arrow pyyaml py-dateutil bokeh pymssql datetime pivottablejs  lightfm gensim pattern tables
RUN pip3 install elasticsearch arrow pyyaml py-dateutil bokeh pymssql datetime pivottablejs lightfm gensim tables

RUN echo 'forcing upgrade for pandas'
RUN echo 'trying to update all pip '
RUN pip2 install -U Cython
RUN pip2 install jupyter
RUN pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip2 install -U
RUN echo 'trying to update all pip3 '
RUN pip3 install -U Cython
RUN pip3 install jupyter
RUN pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip3 install -U

RUN echo 'adding notebook file'
ADD notebook.sh /
RUN chmod u+x /notebook.sh

CMD ["/notebook.sh"]
