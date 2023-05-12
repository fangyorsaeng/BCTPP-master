pageextension 50007 "Item List Ext" extends "Item List"
{
    layout
    {
        modify("Substitutes Exist") { Visible = false; }
        modify("Assembly BOM") { Visible = false; }
        modify("Default Deferral Template Code") { Visible = false; }
        moveafter("Vendor No."; "Production BOM No.")
        moveafter("Production BOM No."; "Routing No.")
        modify("Item Category Code") { Visible = true; }
        modify("Item Tracking Code") { Visible = true; Caption = 'Track Lot'; }
        moveafter("Production BOM No."; "Search Description")
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                ApplicationArea = all;
                Caption = 'Model';
            }
            field(Customer; Customer)
            {
                ApplicationArea = all;
                Caption = 'Customer';
            }

        }
        modify("No.") { CaptionClass = 'Part No.'; }
        modify(Description) { CaptionClass = 'Part Name'; }
        addafter("Base Unit of Measure")
        {

            field("Qty. on Sales Order"; "Qty. on Sales Order") { ApplicationArea = all; }
            field("Qty. on Purch. Order"; "Qty. on Purch. Order") { ApplicationArea = all; }
            field("Qty on Supplier"; "Qty on Supplier") { ApplicationArea = all; }
            field("Inventory On Process"; "Inventory On Process") { ApplicationArea = all; Caption = 'On Process'; }
            field("NG Qty"; "NG Qty") { ApplicationArea = all; }
            field("Group PD"; "Group PD") { ApplicationArea = all; }
            field(Location; Location) { ApplicationArea = all; }
            field("Zone No."; "Zone No.")
            {
                ApplicationArea = all;
            }

        }
        modify("Shelf No.") { Visible = true; }
        moveafter("Description 2"; "Item Category Code")
        modify("Inventory Posting Group") { Visible = true; Caption = 'Type'; }
        modify(InventoryField) { Visible = false; }
        addafter(InventoryField)
        {
            field("Inventory 2"; "Inventory 2")
            {
                ApplicationArea = all;
                Caption = 'Inventory';
            }
        }


    }
    actions
    {
        addafter("Inventory Availability")
        {
            action(InvtByLot)
            {
                Image = Report;
                ApplicationArea = all;
                RunObject = report "Inventory by Lot";
                ToolTip = 'Remain Qty by lot';
                Caption = 'Inventory Availability by Lot';

            }
            action(StockCard)
            {
                Image = Report;
                ApplicationArea = all;
                RunObject = report "Stock Card";
                ToolTip = 'Transection by Item';
                Caption = 'Stock Card';
            }
            action(MaterialStockCard)
            {
                ApplicationArea = all;
                Caption = 'Material Stock Card';
                Image = Report;
                Visible = true;
                trigger OnAction()
                var
                    ItemS: Record Item;
                    MaterialStock: Report "Material Stock Card";
                begin
                    Clear(MaterialStock);
                    ItemS.Reset();
                    ItemS.SetRange("No.", Rec."No.");
                    ItemS.SetRange(Location, Rec.Location);
                    if ItemS.Find('-') then
                        MaterialStock.SetTableView(ItemS);
                    MaterialStock.RunModal();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields("Qty. on Sales Order", "Qty. on Purch. Order", "Qty on Supplier", Customer, "NG Qty", "Inventory 2");
    end;
}