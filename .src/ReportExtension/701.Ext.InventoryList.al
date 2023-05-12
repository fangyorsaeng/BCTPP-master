reportextension 50000 "Inventory List Ex" extends "Inventory - List"
{
    dataset
    {
        modify(item)
        {
            RequestFilterFields = "No.", Description, "Inventory Posting Group", "Item Category Code";
            trigger OnAfterAfterGetRecord()
            begin
                //  ItemS.Get(Item."No.");
            end;
        }
        add(Item)
        {
            column(Inventory; Item.Inventory) { AutoCalcField = true; }
            column(PurchaseOrder; Item."Qty. on Purch. Order") { AutoCalcField = true; }
            column(SalesOrder; Item."Qty. on Sales Order") { AutoCalcField = true; }
            column(ItemCat; Item."Item Category Code") { }

        }



    }
    requestpage
    {

    }
    trigger OnPreReport()
    begin

    end;

    var
        ItemS: Record Item;
}