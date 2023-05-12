pageextension 50038 "Sales Cr.Memo Sub Ex" extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("Qty. Assigned") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("VAT Prod. Posting Group") { Visible = true; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Description 2") { Visible = true; Caption = 'Model'; }
        moveafter("Shortcut Dimension 2 Code"; "Item Reference No.")
        modify("Item Reference No.") { Visible = false; }
        moveafter("Item Reference No."; "VAT Prod. Posting Group")
        addafter("VAT Prod. Posting Group")
        {
            field("Customer Item No."; "Customer Item No.")
            {
                ApplicationArea = all;
            }

        }
        modify("No.")
        {
            CaptionClass = 'Part No.';
            trigger OnAfterValidate()
            var
                ItemS: Record Item;
            begin
                if (Rec."No." <> '') and (Rec.Type = Rec.Type::Item) then begin
                    ItemS.Get(Rec."No.");
                    "Description 2" := ItemS."Description 2";
                    if ItemS.Location <> '' then
                        Validate("Location Code", ItemS.Location);
                    if ItemS."Customer Item Name" <> '' then begin
                        Description := ItemS."Customer Item Name";
                        "Customer Item Name" := ItemS."Customer Item Name";
                        "Customer Item No." := ItemS."Customer Item No.";
                    end;


                end;
            end;
        }
        modify(Description) { CaptionClass = 'Part Name'; }

        modify("Net Weight")
        {
            Visible = true;
        }
        modify("Gross Weight")
        {
            Visible = true;
        }

    }
    actions
    {

    }
}