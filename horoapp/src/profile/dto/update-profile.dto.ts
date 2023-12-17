import { IsArray, IsNumber, IsOptional, IsString } from 'class-validator';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  readonly name?: string;

  @IsOptional()
  @IsString()
  readonly birthday?: string;

  @IsOptional()
  @IsNumber()
  readonly heightInCm?: string;

  @IsOptional()
  @IsNumber()
  readonly weightInKg?: number;

  @IsOptional()
  @IsArray()
  readonly interest?: string[];
}
