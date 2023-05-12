pageextension 50001 "Inventory Setup Ex" extends "Inventory Setup"
{
    layout
    {
        addafter("Location Mandatory")
        {
            field("Skip Check Tracking"; "Skip Check Tracking")
            {
                Caption = 'Skip Check Tacking Code';
                ApplicationArea = all;
            }

        }
    }
}