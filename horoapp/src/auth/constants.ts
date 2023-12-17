export const jwtConstants = {
  secret: 'ThisIsASecretJWTKeyThisShouldBe44CharactersLong',
} satisfies JwtConstants;

export interface JwtConstants {
  secret: string;
}
