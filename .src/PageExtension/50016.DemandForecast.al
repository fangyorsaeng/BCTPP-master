pageextension 50016 "Demand forecast Ex" extends "Demand Forecast Names"
{

    layout
    {
        addafter(Description)
        {
            field(Customer; Customer)
            {
                ApplicationArea = all;
            }
            field("Search Name"; "Search Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}