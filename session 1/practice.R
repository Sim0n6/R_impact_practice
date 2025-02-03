library(cleaningtools)
library(dplyr)

my_raw_data <- cleaningtools::cleaningtools_raw_data
my_kobo_survey <- cleaningtools::cleaningtools_survey
my_kobo_choices <- cleaningtools::cleaningtools_choices


my_data_pii <- check_pii(my_raw_data,
                         uuid_column = "X_uuid")

missing_data_percentage <- my_raw_data%>%
  add_percentage_missing(kobo_survey = my_kobo_survey)%>%
  check_percentage_missing(uuid_column = "X_uuid")

my_check_list <- readxl::read_excel("01 - check_list.xlsx")

check_logical_with_list( dataset =  my_raw_data,
                        uuid_column = "X_uuid",
                        list_of_check = my_check_list,
                        check_id_column = "check_id",
                        check_to_perform_column = "check_to_perform",
                        columns_to_clean_column = "columns_to_clean",
                        description_column ="description")


my_audit <- create_audit_list(audit_zip_path ="audit.zip",
                              dataset = my_raw_data, uuid_column = "X_uuid")
add_duration_from_audit(my_raw_data,
                        audit_list = my_audit,
                        start_question = "X.U.FEFF.start",
                        end_question = "end",
                        col_name_prefix = "duration_audit",
                        uuid_column = "X_uuid")

check_duration(my_raw_data,
               uuid_column = "X_uuid",
               column_to_check = "duration_audit")
