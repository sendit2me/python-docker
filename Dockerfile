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

RUN sudo apt-get install freetds-dev

RUN pip install --upgrade pip
RUN pip3 install --upgrade pip
RUN pip install elasticsearch arrow pyyaml py-dateutil bokeh pymssql datetime pivottablejs  lightfm
RUN pip3 install elasticsearch arrow pyyaml py-dateutil bokeh pymssql datetime pivottablejs lightfm

RUN python3 -c "import bokeh.sampledata; bokeh.sampledata.download()"

pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U

ADD notebook.sh /
RUN chmod u+x /notebook.sh

CMD ["/notebook.sh"]
