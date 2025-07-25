using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FinancIA.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class HopeThisIsTheLastMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Deadline",
                table: "Savings");

            migrationBuilder.DropColumn(
                name: "Month",
                table: "Budgets");

            migrationBuilder.RenameColumn(
                name: "GoalAmount",
                table: "Savings",
                newName: "TargetAmount");

            migrationBuilder.AddColumn<string>(
                name: "ImagePath",
                table: "Transactions",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<DateOnly>(
                name: "TargetDate",
                table: "Savings",
                type: "date",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ColorHex",
                table: "Category",
                type: "nvarchar(12)",
                maxLength: 12,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "IconName",
                table: "Category",
                type: "nvarchar(80)",
                maxLength: 80,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "IsEarningCategory",
                table: "Category",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<Guid>(
                name: "CategoryId1",
                table: "Budgets",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "EndDate",
                table: "Budgets",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<bool>(
                name: "IsRecurring",
                table: "Budgets",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "StartDate",
                table: "Budgets",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateTable(
                name: "SavingTransactions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    SavingId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(19,4)", nullable: false),
                    DateTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Note = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SavingTransactions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SavingTransactions_Savings_SavingId",
                        column: x => x.SavingId,
                        principalTable: "Savings",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Budgets_CategoryId1",
                table: "Budgets",
                column: "CategoryId1");

            migrationBuilder.CreateIndex(
                name: "IX_SavingTransactions_SavingId",
                table: "SavingTransactions",
                column: "SavingId");

            migrationBuilder.AddForeignKey(
                name: "FK_Budgets_Category_CategoryId1",
                table: "Budgets",
                column: "CategoryId1",
                principalTable: "Category",
                principalColumn: "CategoryId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Budgets_Category_CategoryId1",
                table: "Budgets");

            migrationBuilder.DropTable(
                name: "SavingTransactions");

            migrationBuilder.DropIndex(
                name: "IX_Budgets_CategoryId1",
                table: "Budgets");

            migrationBuilder.DropColumn(
                name: "ImagePath",
                table: "Transactions");

            migrationBuilder.DropColumn(
                name: "TargetDate",
                table: "Savings");

            migrationBuilder.DropColumn(
                name: "ColorHex",
                table: "Category");

            migrationBuilder.DropColumn(
                name: "IconName",
                table: "Category");

            migrationBuilder.DropColumn(
                name: "IsEarningCategory",
                table: "Category");

            migrationBuilder.DropColumn(
                name: "CategoryId1",
                table: "Budgets");

            migrationBuilder.DropColumn(
                name: "EndDate",
                table: "Budgets");

            migrationBuilder.DropColumn(
                name: "IsRecurring",
                table: "Budgets");

            migrationBuilder.DropColumn(
                name: "StartDate",
                table: "Budgets");

            migrationBuilder.RenameColumn(
                name: "TargetAmount",
                table: "Savings",
                newName: "GoalAmount");

            migrationBuilder.AddColumn<DateOnly>(
                name: "Deadline",
                table: "Savings",
                type: "DATE",
                nullable: true);

            migrationBuilder.AddColumn<DateOnly>(
                name: "Month",
                table: "Budgets",
                type: "DATE",
                nullable: false,
                defaultValue: new DateOnly(1, 1, 1));
        }
    }
}
