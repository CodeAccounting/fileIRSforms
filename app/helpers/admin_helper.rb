module AdminHelper
    def addT(form_fields)
    #for now only for Form 3921
        #1st 748 records
        returned_data = 'T2016 ' #begining of the file
        data = form_fields['transferors_name_address']
        data = 23-(data.to_s.length)
        data = " "*data
        returned_data += data #23 characters - TRANSFEROR'S federal identification number
        #2nd 748 records
        #3rd 748 records
        #4th 748 records
        #5th 748 records
        #6th 748 records
        #7th 748 records
        #8th 748 records
        #9th 748 records
        #10th 748 records
        #11th 748 records
        #12th 748 records
        #13th 748 records
        #14th 748 records
        #15th 748 records
        #16th 748 records
        #17th 748 records
        #18th 748 records
        #19th 748 records
        #20th 748 records

        return returned_data
    end
end
