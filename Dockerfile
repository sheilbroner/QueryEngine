FROM tiangolo/uwsgi-nginx-flask:python3.7

RUN apt-get update -y && ACCEPT_EULA=Y apt-get install -y \
    apt-transport-https \
    python3-dev \
    build-essential \
    python-numpy \
    python-scipy \
    python-nose \
    python-h5py \
    python-skimage \
    python-matplotlib \
    python-sympy \
    unixodbc \
    unixodbc-dev \
    && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# pip installs
RUN pip --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install --upgrade ipython && \
    pip --no-cache-dir install \
        pyyaml \
        six \
        simplejson \
        jsonschema \
        flask \
        flask-restplus==0.10.1 \
        urllib3==1.24.0 \
        pandas==0.24 \
        pandasql \
        sklearn \
        setuptools \
        azure \
        boto3 \
        xgboost \
        botocore \
        pyspark==2.2.1 \
        google-api-core==1.7.0 \
        google-cloud-storage==1.13.2 \
        google-cloud-bigquery==1.8.1 \
        pyodbc>=4.0.22 \
        azure-storage==0.36.0 \
        matplotlib \
        requests \
        unidecode \
        whoosh \
        werkzeug \
        asyncio \
        websocket-client \
        websockets \
        pytest \
        pytest-runner \
        psycopg2 \
        pytest-cov \
        pylint \
        numpy \
        scipy \
        torch \
        keras \
        jupyter \
        websockets \
        lifelines \
        networkx \
        jupyter \
        openpyxl \
        xlrd \
        tableone \
        cython \
        shap \
        tensorflow \
        SQLAlchemy

# Copy over git token, to be deleted after use
COPY secrets/git_token.txt git_token.txt

# install data_transfer_utility and column_name_mapper

RUN pip --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install \
    git+https://$(cat git_token.txt):x-oauth-basic@github.com/PrecisionHealthIntelligence/data_transfer_utility.git

RUN rm git_token.txt

WORKDIR /QueryEngine
# !the code needs to be copied inside the image!
COPY . /QueryEngine

ENV PYTHONPATH "${PYTONPATH}:/QueryEngine/"

# configure and run jupyter notebook
RUN mkdir /root/.jupyter
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
CMD jupyter notebook -y --allow-root --ip=0.0.0.0 --port=8888 --no-browser

