

 String checkDate(String dateString){

   //  example, dateString = "2020-01-26";

   DateTime checkedTime= DateTime.parse(dateString);
   DateTime currentTime= DateTime.now();

   if((currentTime.year == checkedTime.year)
          && (currentTime.month == checkedTime.month)
              && (currentTime.day == checkedTime.day))
     {
        return "TODAY";

     }
   else if((currentTime.year == checkedTime.year)
              && (currentTime.month == checkedTime.month))
     {
         if((currentTime.day - checkedTime.day) == 1){
           return "YESTERDAY";
         }else if((currentTime.day - checkedTime.day) == -1){
            return "TOMORROW";
         }else{
            return dateString;
         }

     }

 
    return "correct";
  }
