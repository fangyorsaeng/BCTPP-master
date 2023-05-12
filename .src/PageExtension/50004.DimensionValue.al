pageextension 50004 "Dimension Values Ext" extends "Dimension Values"
{
    layout
    {
        addafter(Name)
        {
            field(Description; Description)
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
        }
    }
}