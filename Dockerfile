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

RUN pip install --upgrade pip
RUN pip3 install --upgrade pip
RUN pip install elasticsearch arrow pyyaml py-dateutil bokeh pymssql datetime pivottablejs  lightfm
RUN pip3 install elasticsearch arrow pyyaml py-dateutil bokeh pymssql datetime pivottablejs lightfm

RUN echo 'trying to update all pip '
RUN pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U
RUN echo 'trying to update all pip3 '
RUN pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip3 install -U

RUN echo 'adding notebook file'
ADD notebook.sh /
RUN chmod u+x /notebook.sh

CMD ["/notebook.sh"]
