pageextension 50052 "Assembly Order List Ex" extends "Assembly Orders"
{
    layout
    {
        addbefore("No.")
        {
            field(Status; Status)
            {
                ApplicationArea = all;
            }
        }
        moveafter("No."; "Item No.", Description, "Due Date")
        modify("Document Type") { Visible = false; }
        modify("No.")
        {
            CaptionClass = 'Order No.';
        }
        modify("Due Date")
        {
            CaptionClass = 'Plan Prod. Date';
            StyleExpr = 'Unfavorable';
        }
        modify("Assemble to Order") { Visible = false; }

        modify("Item No.")
        {
            CaptionClass = 'Part No.';
        }
        modify(Description)
        {
            CaptionClass = 'Part Name';
        }
        modify(Quantity)
        {
            CaptionClass = 'Prod. Plan Qty';
        }

        modify("Remaining Quantity")
        {
            CaptionClass = 'Balance Qty/Day';
            Visible = true;

        }
        addafter(Description)
        {
            field("Ref. Part (FG)"; "Ref. Part (FG)")
            {
                ApplicationArea = all;
            }
            field("Item Category"; "Item Category")
            {
                ApplicationArea = all;
            }
            field(Process; Process)
            {
                ApplicationArea = alll;
            }
        }
        modify("Bin Code") { Visible = false; }
        modify("Variant Code") { Visible = false; }
        modify("Starting Date") { Visible = false; }
        modify("Ending Date") { Visible = false; }
        modify("Unit Cost") { Visible = false; }
        modify("Location Code") { Visible = false; }

        addbefore("Due Date")
        {
            field("Posting Date"; "Posting Date")
            {
                CaptionClass = 'Document Date';
            }
        }
        addbefore("Remaining Quantity")
        {
            field("Assembled Quantity"; "Assembled Quantity")
            {
                ApplicationArea = all;
                CaptionClass = 'Prod. Actual';
            }
        }
        addafter("Remaining Quantity")
        {
            field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
            {
                ApplicationArea = all;
            }
            field(Cancel; Cancel)
            {
                ApplicationArea = all;
            }
        }


    }
    actions
    {
        modify("Post &Batch") { Visible = false; }
        modify("P&ost") { Visible = false; }
        addafter("P&osting")
        {
            action("Order2")
            {
                ApplicationArea = Assembly;
                Caption = 'Order';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Print the assembly order.';

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                    AssOrderPrint: Report "Assembly Order Report";
                    AssOrderH: Record "Assembly Header";
                begin
                    //   DocPrint.PrintAsmHeader(Rec);
                    Clear(AssOrderH);
                    Clear(AssOrderPrint);
                    AssOrderH.Reset();
                    AssOrderH.SetRange("No.", Rec."No.");
                    if AssOrderH.Find('-') then begin
                        AssOrderPrint.SetTableView(AssOrderH);
                        AssOrderPrint.Run();
                    end;


                end;
            }
        }
    }
}