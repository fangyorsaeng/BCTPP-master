pageextension 50053 "Assembly Order Card Ex" extends "Assembly Order"
{
    layout
    {
        modify("Starting Date") { Visible = false; }
        modify("Ending Date") { Visible = false; }
        modify("Assemble to Order") { Visible = false; }
        modify("Quantity to Assemble") { Visible = false; }
        modify("Location Code") { Visible = false; }
        modify("Bin Code") { Visible = false; }
        modify("Variant Code") { Visible = false; }
        modify("No.")
        {
            CaptionClass = 'Order No.';
        }
        modify(Description)
        {
            CaptionClass = 'Part Name';
        }
        modify("Posting Date")
        {
            CaptionClass = 'Document Date';
        }
        modify("Due Date")
        {
            CaptionClass = 'Plan Prod. Date';
            trigger OnBeforeValidate()
            var
                AssemblyH: Record "Assembly Header";
            begin
                AssemblyH.Reset();
                AssemblyH.SetRange("Item No.", Rec."Item No.");
                AssemblyH.SetRange("Due Date", Rec."Due Date");
                AssemblyH.SetFilter("No.", '<>%1', Rec."No.");

                if AssemblyH.Find('-') then begin
                    Error('Plan Prod. Date Duplicate!');
                end;

            end;
        }
        modify("Item No.")
        {
            CaptionClass = 'Part No.';

        }
        modify(Quantity)
        {
            CaptionClass = 'Prod. Plan Qty';
        }
        modify("Assembled Quantity")
        {
            CaptionClass = 'Prod. Actual';
        }
        modify("Remaining Quantity")
        {
            CaptionClass = 'Balance Qty/Day';
            Visible = true;

        }

        addafter(Status)
        {
            field(Cancel; Cancel)
            {
                ApplicationArea = all;
            }
        }
        addafter("Quantity to Assemble")
        {
            field("Item Category"; "Item Category")
            {
                ApplicationArea = all;
            }
            field(Process; Process)
            {
                ApplicationArea = all;
            }
        }
        addafter("Item No.")
        {
            field("Ref. Part (FG)"; "Ref. Part (FG)")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("Update Unit Cost")
        {
            Visible = false;
        }
        modify(ShowAvailability)
        {
            Visible = false;
        }
        modify("Post &Batch")
        {
            Visible = false;

        }
        modify("P&ost")
        {
            Visible = false;
        }
        addafter("Update Unit Cost")
        {
            action("Open Material Delivery")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Material Delivery';
                Enabled = true;
                Image = CreateDocuments;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create document from Pick RM to the assembly BOM.';
                Visible = false;

                trigger OnAction()
                begin
                    //UpdateUnitCost;
                end;
            }
            action("Item Ledger Entries2")
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Item Ledger Entries';
                Image = ItemLedger;
                RunObject = Page "Item Ledger Entries";
                RunPageLink = "Order Type" = CONST(Assembly),
                                      "Order No." = FIELD("No.");
                RunPageView = SORTING("Order Type", "Order No.");
                ShortCutKey = 'Ctrl+F7';
                ToolTip = 'View the item ledger entries of the item on the document or journal line.';
            }
        }
        modify("Item Ledger Entries")
        {
            Visible = false;
        }
        modify(Order)
        {
            Visible = false;
        }
        addafter(Order)
        {
            action("Order2")
            {
                ApplicationArea = Assembly;
                Caption = 'Order';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;
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
                    CurrPage.SetSelectionFilter(AssOrderH);
                    AssOrderPrint.SetTableView(AssOrderH);
                    AssOrderPrint.Run();
                end;
            }
        }
    }
}