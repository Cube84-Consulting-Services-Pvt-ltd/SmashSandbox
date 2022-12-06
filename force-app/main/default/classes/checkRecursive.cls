public Class checkRecursive{
    public static boolean run = true; // Changed private to public
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
 }
    }
}