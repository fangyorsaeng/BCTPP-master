pageextension 50008 "Item Card Ex" extends "Item Card"
{
    layout
    {

        modify("Standard Cost")
        {
            Visible = true;
            Editable = true;
        }

        addafter(Item)
        {
            group(ItemDesc)
            {
                Caption = 'Item Detail';
                field("Zone No."; "Zone No.") { ApplicationArea = all; }
                field("PCS per Pallet"; "PCS per Pallet")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Group PD"; "Group PD")
                { ApplicationArea = all; Importance = Promoted; }
                field(Location; Location)
                {
                    Caption = 'Location';
                    ApplicationArea = all;
                }
                field("Default Process"; "Default Process")
                {
                    ApplicationArea = all;
                }
                field("Default Machine"; "Default Machine")
                {
                    ApplicationArea = all;
                }
                field(Classification; Classification) { ApplicationArea = all; }
                field(Material; Material)
                {
                    ApplicationArea = all;
                }
                field(Size; Size)
                {
                    ApplicationArea = all;
                }
                field(Grade; Grade)
                {
                    ApplicationArea = all;
                }

                group(Other)
                {
                    Caption = 'Maker / Vendor';
                    field("Lead Time"; "Lead Time")
                    {
                        ApplicationArea = all;
                        Importance = Promoted;
                    }
                    field(Maker; Maker)
                    {
                        ApplicationArea = all;
                        Importance = Promoted;
                    }
                    field("Vendor Name"; "Vendor Name")
                    {
                        ApplicationArea = all;
                        Importance = Promoted;
                    }
                    field(BOI; BOI)
                    {
                        ApplicationArea = all;
                    }
                    field("Ref. Quotation"; "Ref. Quotation")
                    {
                        ApplicationArea = all;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        var
                            DocAtt: Record "Document Attachment";
                            pageAtt: Page "Document Attach List";
                        begin
                            DocAtt.Reset();
                            DocAtt.SetRange("Table ID", 27);
                            DocAtt.SetRange("No.", Rec."No.");
                            if DocAtt.Find('-') then begin
                                pageAtt.setData(Rec."No.", 'ITEM');
                                pageAtt.SetTableView(DocAtt);
                                pageAtt.RunModal();
                            end;
                        end;
                    }
                    field("Back No."; "Back No.") { ApplicationArea = all; }
                    field("From Material Item"; "From Material Item")
                    {
                        ApplicationArea = all;
                    }
                    field("To Material Item"; "To Material Item")
                    {
                        ApplicationArea = all;
                    }
                    field("For Washing"; "For Washing")
                    {
                        ApplicationArea = all;
                    }
                    field("Cut Stock"; "Cut Stock")
                    {
                        ApplicationArea = all;
                    }


                }
            }
        }

        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                ApplicationArea = all;
                Caption = 'Model';
            }
            field("Customer Item No."; "Customer Item No.")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
            field("Customer Item Name"; "Customer Item Name")
            {
                ApplicationArea = all;
            }
            field("Default Customer"; "Default Customer")
            {
                ApplicationArea = all;
            }

        }
        modify("No.") { CaptionClass = 'Part No.'; }
        modify(Description) { CaptionClass = 'Part Name'; }
        // movebefore(Maker; "Lead Time Calculation")
        modify("Item Tracking Code") { Caption = 'Control Lot'; }
        moveafter("Ref. Quotation"; "Item Tracking Code")
        moveafter(Material; "Shelf No.")


    }
}