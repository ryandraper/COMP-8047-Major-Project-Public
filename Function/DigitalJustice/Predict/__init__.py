import logging
import json
import os
import tempfile

import azure.functions as func
from azure.storage.blob import BlobClient
import pandas as pd
from pandas import json_normalize
import numpy as np
import tensorflow as tf
import pyodbc

BLOBSASURL = os.environ["BLOB_SAS_URL"]
ALL_COLUMNS =   ["appl_has_lawyer",
                "resp_has_lawyer",
                "dispute_type_employment",
                "dispute_type_general small claim",
                "dispute_type_goods or services",
                "dispute_type_housing",
                "dispute_type_loans and debts",
                "dispute_type_personal injury",
                "dispute_type_property dispute",
                "dispute_type_residential contruction",
                "dispute_type_strata",
                "dispute_type_vehicle injury",
                "appl_age_range_19 or under",
                "appl_age_range_20 - 34",
                "appl_age_range_35 - 49",
                "appl_age_range_50 - 64",
                "appl_age_range_65 and over",
                "appl_identity_Asian",
                "appl_identity_Black or Caribbean",
                "appl_identity_Hispanic or Latin",
                "appl_identity_Indiginous",
                "appl_identity_Middle Eastern or North African",
                "appl_identity_Other",
                "appl_identity_Pacific Islander",
                "appl_identity_White",
                "appl_gender_identity_Female",
                "appl_gender_identity_LGBTQ2S+",
                "appl_gender_identity_Male",
                "appl_gender_identity_Other",
                "appl_income_100,000 or more",
                "appl_income_20,000 - 39,000",
                "appl_income_40,000 - 79,000",
                "appl_income_80,000 - 99,000",
                "appl_income_Under 20,000",
                "appl_province_AB",
                "appl_province_BC",
                "appl_province_MB",
                "appl_province_NB",
                "appl_province_NL",
                "appl_province_NS",
                "appl_province_NT",
                "appl_province_NU",
                "appl_province_ON",
                "appl_province_PE",
                "appl_province_QC",
                "appl_province_SK",
                "appl_province_YT",
                "resp_age_range_19 or under",
                "resp_age_range_20 - 34",
                "resp_age_range_35 - 49",
                "resp_age_range_50 - 64",
                "resp_age_range_65 and over",
                "resp_identity_Asian",
                "resp_identity_Black or Caribbean",
                "resp_identity_Hispanic or Latin",
                "resp_identity_Indiginous",
                "resp_identity_Middle Eastern or North African",
                "resp_identity_Other",
                "resp_identity_Pacific Islander",
                "resp_identity_White",
                "resp_gender_identity_Female",
                "resp_gender_identity_LGBTQ2S+",
                "resp_gender_identity_Male",
                "resp_gender_identity_Other",
                "resp_income_100,000 or more",
                "resp_income_20,000 - 39,000",
                "resp_income_40,000 - 79,000",
                "resp_income_80,000 - 99,000",
                "resp_income_Under 20,000",
                "resp_province_AB",
                "resp_province_BC",
                "resp_province_MB",
                "resp_province_NB",
                "resp_province_NL",
                "resp_province_NS",
                "resp_province_NT",
                "resp_province_NU",
                "resp_province_ON",
                "resp_province_PE",
                "resp_province_QC",
                "resp_province_SK",
                "resp_province_YT",
                "tm_age_range_19 or under",
                "tm_age_range_20 - 34",
                "tm_age_range_35 - 49",
                "tm_age_range_50 - 64",
                "tm_age_range_65 and over",
                "tm_identity_Asian",
                "tm_identity_Black or Caribbean",
                "tm_identity_Hispanic or Latin",
                "tm_identity_Indiginous",
                "tm_identity_Middle Eastern or North African",
                "tm_identity_Other",
                "tm_identity_Pacific Islander",
                "tm_identity_White",
                "tm_gender_identity_Female",
                "tm_gender_identity_LGBTQ2S+",
                "tm_gender_identity_Male",
                "tm_gender_identity_Other",
                "tm_province_AB",
                "tm_province_BC",
                "tm_province_MB",
                "tm_province_NB",
                "tm_province_NL",
                "tm_province_NS",
                "tm_province_NT",
                "tm_province_NU",
                "tm_province_ON",
                "tm_province_PE",
                "tm_province_QC",
                "tm_province_SK",
                "tm_province_YT"]

BASE_QUERY = """
    SELECT 
        dd.Dispute_Type dispute_type
        ,ad.Age_Range appl_age_range
        ,ad.[Identity] appl_identity
        ,ad.Gender_identity appl_gender_identity
        ,ad.Household_income appl_income
        ,ad.Is_Lawyer appl_has_lawyer
        ,ad.Province appl_province
        ,rd.Age_Range resp_age_range
        ,rd.[Identity] resp_identity
        ,rd.Gender_identity resp_gender_identity
        ,rd.Household_income resp_income
        ,rd.Is_Lawyer resp_has_lawyer
        ,rd.Province resp_province
        ,tmd.Age_Range tm_age_range
        ,tmd.[Identity] tm_identity
        ,tmd.Gender_identity tm_gender_identity
        ,tmd.Province tm_province
        ,df.[In_favour_of_Applicant]
    FROM [dbo].[Decision Fact] df
    INNER JOIN [Dispute DIM] dd
    ON df.Dispute_DIM = dd.[ID] 
    INNER JOIN [Applicant DIM] ad
    ON df.[Applicant_DIM] = ad.[ID]
    INNER JOIN [Respondent DIM] rd
    ON df.[Respondent_DIM] = rd.[ID]
    INNER JOIN [Tribunal Member DIM] tmd
    ON df.Tribunal_Member_DIM = tmd.[ID]
    WHERE 
    """

def buildQuery(req_params,base):
    logging.info("checking first param")
    logging.info(req_params["dispute_type"])
    final_query = (base 
    + " dd.Dispute_Type = \'" + req_params["dispute_type"] +"\'"
    + " AND ad.Age_Range = \'" + req_params["appl_age_range"] +"\'"
    + " AND ad.[Identity] = \'" + req_params["appl_identity"] +"\'"
    + " AND ad.Gender_identity = \'" + req_params["appl_gender_identity"] +"\'"
    + " AND ad.Household_income = \'" + req_params["appl_income"] +"\'"
    + " AND ad.Is_Lawyer = \'" + req_params["appl_has_lawyer"] +"\'"
    + " AND ad.Province = \'" + req_params["appl_province"] +"\'"
    + " AND rd.Age_Range = \'" + req_params["resp_age_range"] +"\'"
    + " AND rd.[Identity] = \'" + req_params["resp_identity"] +"\'"
    + " AND rd.Gender_identity = \'" + req_params["resp_gender_identity"] +"\'"
    + " AND rd.Household_income = \'" + req_params["resp_income"] +"\'"
    + " AND rd.Is_Lawyer = \'" + req_params["resp_has_lawyer"] +"\'"
    + " AND rd.Province = \'" + req_params["resp_province"] +"\'"
    + " AND tmd.Age_Range = \'" + req_params["tm_age_range"] +"\'"
    + " AND tmd.[Identity] = \'" + req_params["tm_identity"] +"\'"
    + " AND tmd.Gender_identity = \'" + req_params["tm_gender_identity"] +"\'"
    + " AND tmd.Province = \'" + req_params["tm_province"]) +"\'"

    return final_query
     

def download_from_blob_storage(function_path):
    """
    Returns a file downloaded from Azure Storage
    file_name_ext: The file name to fetch
    """
    logging.info("download_from_blob_storage STARTING")

    local_path = tempfile.gettempdir()
    filepath = os.path.join(local_path, "model.h5")

    blob_client = BlobClient.from_blob_url(BLOBSASURL)
    download_stream = blob_client.download_blob()

    try:
        with open(file=filepath, mode="wb") as unpacked_model:
            unpacked_model.write(download_stream.readall())
    except ValueError as e:
        logging.info(e)
        pass

    logging.info("download_from_blob_storage ENDING")
    return filepath

def one_hot_encode(dataframe):
    """
    Since the one hot encoded dataframe passed in only has 1 row it will only have the true values.
    We need to expand the dataframe to a true one_hot encoded dataframe by adding all the false value columns.
    """
    columns = dataframe.columns
    one_hot_result = {}
    for col in columns:
        one_hot_related_columns = [oh_col for oh_col in ALL_COLUMNS if oh_col.startswith(col)]
        logging.info("one_hot_related_columns: ")
        # logging.info(one_hot_related_columns)
        for oh_column in one_hot_related_columns:
            if oh_column.endswith(dataframe[col][0]):
                one_hot_result[oh_column] = 1
            else:
                one_hot_result[oh_column] = 0
    return one_hot_result

def getRecordCount(req_params):
    query = buildQuery(req_params)
    logging.info(query)

def main(req: func.HttpRequest, context: func.Context) -> func.HttpResponse:
    logging.info('Decision Predictor running...')

    req_json = req.get_json()
    rowcount = 0
    try:
        server = os.environ["SQL_SERVER"]
        database = os.environ["SQL_DB"]
        username = os.environ["SQL_USERNAME"]
        password = os.environ["SQL_PASSWORD"]
        driver= '{ODBC Driver 17 for SQL Server}'
        query = buildQuery(req_json, BASE_QUERY)
        logging.info("CONSTRUCTED QUERY")
        logging.info(query)
        rowcount = 0
        with pyodbc.connect('DRIVER='+driver+';SERVER=tcp:'+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password) as conn:
            with conn.cursor() as cursor:
                cursor.execute(query)
                rowcount = len(cursor.fetchall())
                # while row:
                #     logging.info(row)
                #     finaloutput = finaloutput + (row[0])
                #     row = cursor.fetchone()

        logging.info('rowcount')
        logging.info(rowcount)
        # logging.info(req.params)
    except ValueError as e:
        logging.info(e)

    model_file_path = download_from_blob_storage(context.function_directory)
    logging.info(model_file_path)
    
    loaded_model = tf.keras.models.load_model(model_file_path)
    logging.info(loaded_model)

    req_df = ''
    pred = ''
    pred_val = 0

    try:
        req_df = json_normalize(req_json)
        logging.info(req_df)
        logging.info("DATAFRAME req_df")
       
        one_hot_dict = one_hot_encode(req_df)
        one_hot_df = pd.DataFrame(one_hot_dict, index=[0])
       
        pred = loaded_model.predict(one_hot_df)
        logging.info("PRED!")
        logging.info(pred[0])
        pred_val = pred.tolist()[0][0]
        logging.info(pred_val)
        logging.info(type(pred_val))
        
    except ValueError as e:
        logging.info(e)
        pass

    if pred_val:
        content = {"pred":pred_val,"rowcount":rowcount}
        logging.info(content)
        logging.info(type(content))

        return func.HttpResponse(
            json.dumps(content),
            mimetype="application/json"
        )
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully but was missing json data from input.",
             status_code=200
        )
