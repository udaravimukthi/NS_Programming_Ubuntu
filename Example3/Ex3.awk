BEGIN{
drop=0;
}
{
if($1=="d")
{
    drop++;
}

}

END{

printf("Total Number of %s packets dropped due to congession=%d\n",$5,drop);

}

